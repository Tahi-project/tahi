# Copyright (c) 2018 Public Library of Science

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

require 'rails_helper'
# rubocop:disable Metrics/ModuleLength
module MailLog::LogToDatabase
  describe DeliveringEmailInterceptor do
    subject(:interceptor) { described_class }

    describe '.delivering_email' do
      let(:mail) do
        Mail::Message.new do
          from 'apertian@example.org'
          to ['curtis@example.com', 'zach@example.com']
          subject 'This is a test email'
          message_id 'abc123'
          body 'This is a test email\'s body'
        end
      end

      it 'logs the email without attachments to the database' do
        expect do
          interceptor.delivering_email(mail)
        end.to change { Correspondence.count }.by(+1)
        email_log = Correspondence.last
        expect(email_log.sender).to eq 'apertian@example.org'
        expect(email_log.recipients).to eq 'curtis@example.com, zach@example.com'
        expect(email_log.message_id).to eq 'abc123'
        expect(email_log.body).to eq 'This is a test email\'s body'
        expect(email_log.raw_source).to eq mail.to_s
        expect(email_log.status).to eq 'pending'
        expect(email_log.sent_at).to be nil
        expect(email_log.errored_at).to be nil
        expect(email_log.journal).to be nil
        expect(email_log.paper).to be nil
        expect(email_log.task).to be nil
      end

      let(:correspondence_double) { double('Correspondence') }
      let(:attachment_double) { double('CorrespondenceAttachment') }

      it 'logs the email with attachments to the database whilst storing attachments' do
        allow(Correspondence).to receive(:create!).and_return(correspondence_double)
        expect(correspondence_double).to receive_message_chain('attachments.create!') { attachment_double }
        expect(attachment_double).to receive(:file).and_return(true)
        expect(attachment_double).to receive(:create_resource_token!).and_return(true)
        expect(attachment_double).to receive(:update).with(status: 'done')
        mail.attachments['test'] = StringIO.new('testing')
        mail.html_part = 'This is a test email\'s body'
        interceptor.delivering_email(mail)
      end

      context 'and additional context is provided for the email' do
        subject(:perform_delivering_email) do
          mail.aperta_mail_context = MailLog::ApertaMailContext.new(context_hash)
          interceptor.delivering_email(mail)
        end
        let(:attachment) { FactoryGirl.create(:attachment) }
        let(:task) { FactoryGirl.create(:ad_hoc_task) }
        let(:paper) { FactoryGirl.create(:paper) }
        let(:journal) { FactoryGirl.create(:journal) }
        let(:email_log) { Correspondence.last }

        let(:context_hash) do
          {
            '@task' => task,
            '@paper' => paper,
            '@journal' => journal,
            '@attachment' => attachment,
            '@not_activerecord_model' => Object.new
          }
        end

        it 'sets the Correspondence#task to the first Task' do
          perform_delivering_email
          expect(email_log.task).to eq task
        end

        it 'sets the Correspondence#paper to the first Paper' do
          perform_delivering_email
          expect(email_log.paper).to eq paper
        end

        context 'and there is no Paper in the context' do
          before do
            context_hash.delete('@paper')
          end

          it "sets the Correspondence#paper to the task's paper when it's available" do
            perform_delivering_email
            expect(email_log.paper).to eq(task.paper)
            expect(email_log.paper).to_not eq(paper)
          end

          it "sets the Correspondence#paper to the first Paper instance when the instance variable is named something other than /paper/" do
            context_hash.delete('@task')
            misnamed_paper = FactoryGirl.create(:paper)
            context_hash['@misnamed'] = misnamed_paper
            perform_delivering_email
            expect(email_log.paper).to eq(misnamed_paper)
            expect(email_log.paper).to_not eq(task.paper)
            expect(email_log.paper).to_not eq(paper)
          end

          it "sets the Correspondence#paper to the first associated paper found when @task.paper and @paper are blank" do
            context_hash.delete('@task')
            attachment.paper = FactoryGirl.create(:paper)
            perform_delivering_email
            expect(email_log.paper).to eq(attachment.paper)
            expect(email_log.paper).to_not eq(task.paper)
            expect(email_log.paper).to_not eq(paper)
          end
        end

        it 'sets the Correspondence#journal to the first Journal' do
          perform_delivering_email
          expect(email_log.journal).to eq journal
        end

        context 'and there is no Journal in the context' do
          before do
            context_hash.delete('@journal')
          end

          it "sets the Correspondence#journal to the paper's journal" do
            perform_delivering_email
            expect(email_log.journal).to eq(paper.journal)
            expect(email_log.journal).to_not eq(journal)
          end
        end

        it 'sets Correspondence#additional_context to include all of the activerecord models in the mail context' do
          perform_delivering_email
          expect(email_log.additional_context).to eq("@task" => ["AdHocTask", task.id],
                                                     "@paper" => ["Paper", paper.id],
                                                     "@journal" => ["Journal", journal.id],
                                                     "@attachment" => ["Attachment", attachment.id])
          expect(email_log.additional_context.keys).to_not include '@not_activerecord_model'
        end
      end

      it 'inserts known recipient names, first known, then unknown' do
        user = FactoryGirl.create(:user, email: mail.to.last)
        interceptor.delivering_email(mail)
        expect(Correspondence.last.recipients).to eq("#{user.full_name} <#{mail.to.last}>, #{mail.to.first}")
      end
    end

    describe '.get_message' do
      let(:message) { double('Message', body: 'wat', html_part: html_part) }
      context 'message has an html_part' do
        let(:html_part) { double('MessagePart', body: 'html wat') }
        it 'returns the message html_part body' do
          expect(interceptor.get_message(message)).to be(html_part.body)
        end
      end
      context 'message has no html_part' do
        let(:html_part) { nil }
        it 'returns the message body' do
          expect(interceptor.get_message(message)).to be(message.body)
        end
      end
    end
  end

  describe DeliveredEmailObserver do
    subject(:observer) { described_class }

    describe '.delivered_email' do
      let(:mail) do
        Mail::Message.new do
          message_id 'abc123'
        end
      end

      let!(:email_log) do
        Correspondence.create!(message_id: 'abc123', status: 'pending', sent_at: DateTime.now.in_time_zone)
      end

      it 'marks the logged email record as sent' do
        expect do
          observer.delivered_email(mail)
        end.to change { email_log.reload.status }.from('pending').to('sent')
      end

      it 'sets the sent_at timestamp on the logged email record' do
        Timecop.freeze do |now|
          observer.delivered_email(mail)
          expect(email_log.reload.sent_at).to be_within_db_precision.of(now)
        end
      end
    end
  end

  describe EmailExceptionsHandler do
    subject(:delivery_handler) { described_class.new }

    describe '.deliver_mail' do
      let(:mail) do
        Mail::Message.new do
          message_id 'abc123'
        end
      end

      let!(:email_log) do
        Correspondence.create!(message_id: 'abc123', status: 'sent', sent_at: DateTime.now.in_time_zone)
      end

      it 'yields the given block' do
        expect do |block|
          delivery_handler.deliver_mail(mail, &block)
        end.to yield_control
      end

      context 'when the given block raises an exception' do
        let(:deliver_mail_with_exception) do
          expect do
            delivery_handler.deliver_mail(mail) { raise Exception, "It failed!" }
          end.to raise_error(Exception)
        end

        it 'sets the logged email record status to failed; raises the exception' do
          deliver_mail_with_exception
          email_log.reload
          expect(email_log.status).to eq('failed')
          expect(email_log.error_message).to eq('It failed!')
        end

        it 'sets the failed_at timestamp on the logged email record' do
          Timecop.freeze do |now|
            deliver_mail_with_exception
            expect(email_log.reload.errored_at).to be_within_db_precision.of(now)
          end
        end
      end
    end
  end
end
