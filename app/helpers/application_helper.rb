module ApplicationHelper
  def bootstrap_class_for(flash_type)
      case flash_type
          when "notice"
          "success"
          when "alert"
          "info"
          else
          flash_type.to_s
      end
  end
end
