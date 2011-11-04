module UsersHelper
  def label_and_field (form, item)
    raw ""+(form.label item)+""+(form.text_field item)
  end
end
