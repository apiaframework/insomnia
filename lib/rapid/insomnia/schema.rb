# frozen_string_literal: true

module Rapid
  module Insomnia
    class Schema

      def initialize(api, base_url)
        @api = api
        @base_url = base_url
        @spec = {
          '_type' => 'export',
          '__export_format' => 3,
          '__export__date' => Time.now.to_s,
          'resources' => []
        }
        setup
      end

      def json
        @spec.to_json
      end

      private

      def setup
        add_resource('workspace', '__WORKSPACE_ID__',
                     name: @api.definition.name,
                     description: @api.definition.description)

        add_resource('environment', get_id('environment', @api),
                     name: 'Default Environment',
                     data: {
                       base_url: @base_url,
                       bearer_token: 'Add token here...'
                      })

        add_groups(@api.definition.route_set.groups)
        add_requests(@api.definition.route_set.routes)
      end

      def add_groups(groups)
        groups.sort_by(&:name).each_with_index do |group, index|
          add_resource('request_group', get_id('folder', group), {
            name: group.name,
            parentId: get_id('folder', group.parent),
            metaSortKey: index,
            enivronment: {}
          })
          add_groups(group.groups) if group.groups
        end
        nil
      end

      def add_requests(routes)
        routes.each do |route|
          next unless route.endpoint.definition.schema?

          hash = {
            name: route.endpoint.definition.name,
            description: route.endpoint.definition.description,
            url: "{{ base_url }}/#{route.path}",
            parentId: get_id('folder', route.group),
            method: route.request_method.to_s.upcase
          }

          authenticator = route.endpoint.definition.authenticator ||
                          route.controller.definition.authenticator ||
                          @api.definition.authenticator

          case authenticator&.definition&.type
          when :bearer
            hash[:authentication] = { type: 'bearer', token: '{{ bearer_token }}' }
          end

          if route.request_method == :get
            hash[:parameters] = []
            add_parameters_to_array(hash[:parameters], route.endpoint.definition.argument_set)

          else
            hash[:body] = { mimeType: 'application/json' }
            hash[:headers] = [{ name: 'Content-Type', value: 'application/json' }]

            body_arguments = {}
            add_arguments_to_hash(body_arguments, route.endpoint.definition.argument_set)
            hash[:body][:text] = JSON.pretty_generate(body_arguments)
          end

          add_resource('request', get_id('request', route), hash)
        end
      end

      def add_parameters_to_array(array, set, prefix = '')
        set.definition.arguments.each_value do |arg|
          if arg.type.argument_set?
            sub_array = []
            add_parameters_to_array(sub_array, arg.type.klass, arg.name.to_s)
            sub_array.each { |a| array << a }
          else

            if prefix.empty?
              name_for_param = arg.name.to_s
            else
              name_for_param = prefix + "[#{arg.name}]"
            end

            param = {
              name: name_for_param,
              value: nil,
              disabled: !arg.required?
            }
            array << param
          end
        end
      end

      def add_arguments_to_hash(hash, set)
        set.definition.arguments.each_value do |arg|
          name_for_hash = arg.name.to_s
          hash[name_for_hash] = get_default_value_for_argument(arg)
        end
      end

      def get_default_value_for_argument(argument)
        if argument.type.argument_set? && argument.type.klass.definition.is_a?(Rapid::Definitions::LookupArgumentSet)
          {
            argument.type.klass.definition.arguments.values.map(&:name).join('|') => ''
          }
        elsif argument.type.argument_set?
          hash = {}
          add_arguments_to_hash(hash, argument.type.klass)
          hash
        elsif argument.type.enum?
          argument.type.klass.definition.values.keys.join(' | ')
        end
      end

      def add_resource(type, id, options)
        @spec['resources'] << {
          '_type' => type,
          '_id' => id
        }.merge(options)
      end

      def get_id(prefix, object)
        return nil if object.nil?

        prefix = prefix.upcase

        @ids ||= {}
        @ids[prefix] ||= []
        unless @ids[prefix].include?(object)
          @ids[prefix] << object
        end
        id = @ids[prefix].index(object) + 1
        "__#{prefix}_#{id}__"
      end

    end
  end
end
