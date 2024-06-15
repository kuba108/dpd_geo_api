# frozen_string_literal: true

module DpdGeoApi
  class ResponseValidator

    def validate_response(response)
      errors = []
      if (200..299).exclude?(response.response_status)
        # raise "Error in progress!"
        packages_results = response.body.map { |k,v| v if k != 'status' }.compact
        packages_results.each do |package_result|
          if package_result['errors'].present?
            package_result['errors'].values.each do |package_error|
              errors << package_error
            end
          end
        end
      end
      errors
    end

  end
end
