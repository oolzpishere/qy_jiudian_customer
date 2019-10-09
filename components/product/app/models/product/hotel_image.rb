module Product
  class HotelImage < ApplicationRecord
    self.table_name = :hotel_images

    belongs_to :hotel
    has_one_attached :image

    include Rails.application.routes.url_helpers
    def to_jq_upload
      # byebug
      {
        "name" => image.filename,
        "size" => image.byte_size,
        "url" => rails_blob_path(image, only_path: true),
        "thumbnailUrl" => rails_representation_path(image.variant(resize: "150"), only_path: true),
        "deleteUrl" => "/manager/hotel_images/#{self.id}",
        "deleteType" => "DELETE"
      }
    end

  end
end
