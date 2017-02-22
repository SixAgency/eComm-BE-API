class Swagger::Docs::Config
  def self.base_application; Spree::Core::Engine end
end

Swagger::Docs::Config.register_apis(
    {
        "1.0" => {
            # the extension used for the API
            :api_extension_type => :json,
            # the output location where your .json files are written to
            :api_file_path      => "public/docs/",
            # the URL base path to your API
            :base_path          => "http://krissorbie.com/docs",
            # if you want to delete all .json files at each generation
            :clean_directory    => false,
            # Ability to setup base controller for each api version. Api::V1::SomeController for example.
            # :parent_controller => Spree::Api::BaseController,
            # add custom attributes to api-docs
            :attributes         => {
                :info => {
                    "title"             => "Spree API documentation",
                    "description"       => "This will be used to document new or update code.",
                    "termsOfServiceUrl" => "http://helloreverb.com/terms/",
                    "contact"           => "daniel.boldan@clever-software-solutions.com",
                    "license"           => "Apache 2.0",
                    "licenseUrl"        => "http://www.apache.org/licenses/LICENSE-2.0.html"
                }
            }
        }
    }
)
