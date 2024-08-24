require_relative './base'

module SfCli
  class Sf
    class Project < Base
      GenerateResult = Struct.new(:output_dir, :files, :raw_output, :warnings)

      def generate(name, manifest: false, template: nil, output_dir: nil)
        flags    = {
          :name         => name,
          :template     => template,
          :"output-dir" => output_dir,
        }
        switches = {
          manifest: manifest,
        }
        json = exec(__method__, flags: flags, switches: switches, redirection: :null_stderr)

        GenerateResult.new(
          output_dir: json['result']['outputDir'],
          files:      json['result']['created'],
          raw_output: json['result']['rawOutput'],
          warnings:   json['warnings']
        )
      end

      def generate_manifest(name: nil, output_dir: nil, api_version: nil, metadata: [], from_org: nil, source_dir: nil)
        flags    = {
          :name           => name,
          :"metadata"     => (metadata.empty? ? nil : metadata.join(' ')),
          :"from-org"     => from_org,
          :"source-dir"   => source_dir,
          :"output-dir"   => output_dir,
          :"api-version"  => api_version,
        }
        action = __method__.to_s.tr('_', ' ')
        json = exec(action, flags: flags, redirection: :null_stderr)

        json['result']['path']
      end
    end
  end
end
