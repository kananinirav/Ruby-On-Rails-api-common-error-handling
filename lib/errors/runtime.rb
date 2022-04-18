# frozen_string_literal: true

# Errors Example
# raise Errors::ApplicationError.new I18n.t(:unexpected, scope: [:api, :errors])
# raise Errors::Runtime::ActionFailed, :unexpected # if in controller
# raise Errors::Runtime::ServiceFailed, :unexpected # if in service
# raise Errors::Runtime::StandarError.new(:controller, :unexpected) # if in controller
# raise Errors::Runtime::StandarError.new(:service, :unexpected) # if in service

module Errors
  module Runtime
    # StandarError
    class StandarError < Errors::ApplicationError
      attr_reader :type, :detail

      def initialize(type, detail)
        @type = type
        @detail = detail
        scope = i18n_scope
        # error = I18n.t detail, scope: scope, default: translation_missing(detail, scope)
        error = I18n.t detail, scope: scope
        @code = error[:code]
        @message = error[:message]
      end

      private

      def i18n_scope
        backtrace = caller 0, 5
        matches_file = backtrace.last.match(file_path_regex) || backtrace[2].match(file_path_regex)
        file_path = matches_file[0]
        file_path.split(%r{/})[3..].map { |e| e.gsub file_suffix, '' }
      end

      def file_path_regex
        case type
        when :controller
          %r{/app/(controllers)/.*\.rb}
        when :service
          %r{/app/(services)/.*\.rb}
        end
      end

      def file_suffix
        case type
        when :controller
          /_controller.rb/
        when :service
          /_service.rb/
        end
      end

      def translation_missing(detail, scope)
        prefix_msg = "translation missing: #{scope.push(detail.to_s).join('.')}"
        {
          code: "#{prefix_msg}.code",
          message: "#{prefix_msg}.message"
        }
      end
    end

    # ActionFailed
    class ActionFailed < Errors::Runtime::StandarError
      def initialize(detail)
        super :controller, detail
      end
    end

    # ServiceFailed
    class ServiceFailed < Errors::Runtime::StandarError
      def initialize(detail)
        super :service, detail
      end
    end
  end
end
