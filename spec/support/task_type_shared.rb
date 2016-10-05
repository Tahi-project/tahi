shared_context 'clean Task.descendants' do
  before do
    # Filter out anonymous test classes.
    # This allows us to create test descendants of Task without polluting this.
    allow(Task).to receive(:descendants).and_wrap_original do |m|
      retval = m.call.reject { |klass| klass.name.nil? }
      # These classes didn't work with an anoymous class
      retval -= [InvitableTestTask] if defined? InvitableTestTask
      retval -= [MetadataTestTask] if defined? MetadataTestTask
      retval
    end
  end
end
