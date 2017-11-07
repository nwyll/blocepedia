module ApplicationHelper
  def form_group_tag(errors, &block)
    css_class = 'form-group'
    css_class << ' has-error' if errors.any?
    content_tag :div, capture(&block), class: css_class
  end
  
  def markdown(text)
    render_options = {
      filter_html:          true,
      hard_wrap:            true
    }
    
    extensions = {
      autolink:                     true,
      no_intra_emphasis:            true,
      superscript:                  true,
      highlight:                    true,
      disable_indented_code_blocks: true,
      fenced_code_blocks:           true
    }
    
    renderer = Redcarpet::Render::HTML.new(render_options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    
    markdown.render(text).html_safe
  end
end
