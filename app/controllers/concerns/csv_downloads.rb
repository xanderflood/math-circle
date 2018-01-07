require 'csv'

module CsvDownloads
  extend ActiveSupport::Concern

  class PreconditionError < StandardError; end

  class_methods do
    def csv_download(action_name, options={})
      define_method(action_name) do
        unless self.instance_variables.include? options[:object]
          raise PreconditionError("Instance variable \"#{options[:object].to_s}\"")
        end

        obj = self.instance_variable_get(options[:object])

        output = CSV.generate_line(options[:header].call(obj))
        options[:data].call(obj).each do |row|
          output << CSV.generate_line(row)
        end

        send_data output, filename: options[:filename].call(obj), type: 'text/csv'
      end
    end
  end
end
