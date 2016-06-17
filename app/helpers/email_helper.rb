
module EmailHelper

  @@font_family = "'Helvetica Neue',Helvetica,Roboto,Arial,sans-serif;"
  @@button_style = 'padding-top: 1rem; padding-right: 1.25rem; padding-bottom: 1rem; padding-left: 1.25rem; font-size: 1rem; display: inline-block; border-style: solid; border-width: 0; cursor: pointer; font-family: "Helvetica Neue",Helvetica,Roboto,Arial,sans-serif; font-weight: normal; line-height: normal; margin: 0 0 1.25rem 0; position: relative; text-decoration: none; text-align: center; -webkit-appearance: none; border-radius: 0; background-color: rgb(248, 152, 29); color: rgb(255, 255, 255);'

  def email_heading(text)
    item = '<div style="color: rgb(248, 152, 29);
          font-weight: 200;
          font-size: 30px;
          line-height: .9;
          text-rendering: optimizeLegibility;
          margin-top: 1rem;
          font-family:' + @@font_family + '">'  + text + '</div>'
    item.html_safe
  end

  def email_subheading(text)
    item = '<div style="color: rgb(50, 50, 50);
          font-weight: 200;
          font-size: 20px;
          margin-top: 20px;
          margin-bottom: 3rem;
          text-rendering: optimizeLegibility;
          font-family:' + @@font_family +'">'  + text + '</div>'
    item.html_safe
  end

  def email_text(text)
    item = '<div style="color: rgb(50, 50, 50);
          font-weight: 200;
          font-size: 16px;
          margin-top: 10px;
          margin-bottom: 2rem;
          text-rendering: optimizeLegibility;
          font-family:' + @@font_family +'">'  + text + '</div>'
    item.html_safe
  end

  def email_button(text, url)

    link_to text, url,
            :style => @@button_style
  end

end