##################################################################################################
## This concern allows models to extend into responding to their accessibility by a given user login.
## Common use cases will be whether a resource object is editable or only readable by a user.
##
## Convention here will be reflected by values given to specific permissions.
## Ideally the individual model with take care of any customization above and beyond convention.
##################################################################################################


class ResourceAccessibility
  extend ActiveSupport::Concern

  module ClassMethods


  end
end