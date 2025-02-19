module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice, :success
      "bg-green-800 text-green-100 border border-green-700"
    when :alert, :error
      "bg-red-800 text-red-100 border border-red-700"
    when :warning
      "bg-yellow-800 text-yellow-100 border border-yellow-700"
    else
      "bg-purple-800 text-purple-100 border border-purple-700"
    end
  end
end
