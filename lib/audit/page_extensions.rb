module Audit
  module PageExtensions

    def self.included(base)
      # add to this if you want to fire off separate AuditEvents when particular fields are
      # updated-- i.e. add :status_id to observe when the page's status changes.
      # see audit_event :status_change below for how to handle such an event
      base.const_set("OBSERVABLE_FIELDS", [])

      base.class_eval do
        extend Auditable
        extend Auditor

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.title, event.auditable_path) + " (" + link_to("link", edit_admin_page_path(event.auditable.id)) + ")"
        end
        
        audit_event :update do |event|
          log_message = "#{event.user_link} updated " + link_to(event.auditable.title, event.auditable_path)
          log_message += " to revision #{event.auditable.revisions.first.number}"
          log_message += " (" + link_to("link", edit_admin_page_path(event.auditable.id)) + ")"
          log_message
        end
        
        # separate event for logging page status changes- fired after page :update if the status has changed.
        audit_event :status_change do |event|
          oldstatus = Status.find_all.reject{|x| x.id != event.auditable.status_id_was}.first.name
          log_message = "#{event.user_link} changed the status of " + link_to(event.auditable.title, event.auditable_path)
          log_message += " from #{oldstatus}" unless oldstatus.blank?
          log_message += " to #{event.auditable.status.name}"
          log_message += " (" + link_to("link", edit_admin_page_path(event.auditable.id)) + ")"
        end
        
        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.title, event.auditable_path)
        end

        def self.updated_fields(updatables, auditable)
          updated_fields = auditable.parts.inject(super||[]) do |updates,part|
            updates << part.name if part.changed?
            updates
          end
          updated_fields.any? ? updated_fields : nil
        end
      end
    end

  end
end