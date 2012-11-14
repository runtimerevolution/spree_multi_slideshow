module Spree
  module Admin
    class SlidesController < ResourceController
      before_filter :load_data, :only => [:index, :new, :show, :edit, :create, :update]
      
      def update_positions
        params[:positions].each do |id, index|
          Spree::Slide.update_all(['position=?', index], ['id=?', id])
        end

        respond_to do |format|
          format.html { redirect_to admin_slideshow_type_slides_url(@slideshow_type) }
          format.js  { render :text => 'Ok' }
        end
      end

      protected
      def location_after_save
        admin_slideshow_type_slides_url(@slideshow_type)
      end
      
      def load_data
        params_hash = params[:slide] ? params[:slide] : params       
        @slideshow_type = Spree::SlideshowType.find(params_hash[:slideshow_type_id].to_i)
      end

    end
  end
end
