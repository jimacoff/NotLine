class AvatarUploader < ApplicationUploader
  version :thumb do
    process resize_and_pad: [200, 200]
  end

  version :small do
    process resize_and_pad: [500, 500]
  end
end
