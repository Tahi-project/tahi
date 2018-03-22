##
# Serializer for a single, reified permission as returned by
# user#filter_authorized
#
class PermissionResultSerializer < AuthzSerializer
  def serializable_hash(*args)
    hash = super(*args)
    hash.merge(
      id: "#{object.object[:type].demodulize
                                 .camelize(:lower)}+#{object.object[:id]}",
      object: {
        id: object.object[:id],
        type: object.object[:type].demodulize
      },
      permissions: object.permissions
    )
  end

  private

  # TODO: APERTA-12693 Stop overriding this
  def can_view?
    true
  end
end
