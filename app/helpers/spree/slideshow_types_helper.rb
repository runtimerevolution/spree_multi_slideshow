# encoding: UTF-8
module Spree
  module SlideshowTypesHelper

    def insert_slideshow(params={})
      if slide_images(params)
        navigation = enable_navigation(params)
        content_tag(:div, navigation[:prev] + content_tag(:div, content_tag(:ul, raw(slide_images(params))), :class => "gallery-inner clearfix") + navigation[:succ], :class => "gallery #{params[:class]}", :style => "width: #{Spree::SlideshowType.enable(params[:category] || "home").first.slide_width}px; height: #{Spree::SlideshowType.enable(params[:category] || "home").first.slide_height}px;")
      end
    end

    def slide_images(params)
      category = params[:category] || "home"
      style = params[:style] || "custom"
      slideshow = Spree::SlideshowType.enable(category)
      if !slideshow.blank?
        max = slideshow.first.slide_number || 4
        slides = slideshow.first.slides.order(:position).limit(max)

        slides.map do |slide|
          if params[:enable_content]
            link_content = content_tag(:div, content_tag(:strong, raw(slide.title)) + content_tag(:p, raw(slide.content)), :class => "text-holder")
          else
            link_content = ""
          end
          if slide.html_content.blank?
            content_tag(:li, raw(link_to(image_tag(slide.attachment.url(style.to_sym)), slide.url, { :title => slide.title })) + raw(link_content))
          else
            content_tag(:li, raw(slide.html_content))
          end
        end.join
      else
        false
      end
    end

    def enable_navigation(params)
      category = params[:category] || "home"
      slideshow = Spree::SlideshowType.enable(category)
      if !slideshow.blank?
        if slideshow.first.enable_navigation
          prev = link_to("‹", "#", :class => "gallery-control left")
          succ = link_to("›", "#", :class => "gallery-control right")
        else
          prev = ""
          succ = ""
        end
        
        res = Hash.new()
        if slideshow.first.enable_navigation
          res[:prev] = content_tag(:div, prev, :class => "carousel-control left")
          res[:succ] = content_tag(:div, succ, :class => "carousel-control right")
        else
          res[:prev] = content_tag(:div, prev, :class => "")
          res[:succ] = content_tag(:div, succ, :class => "")
        end
        return res
      end
    end
    
  end
end