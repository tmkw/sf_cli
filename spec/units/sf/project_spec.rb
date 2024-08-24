RSpec.describe 'SfCli::Sf::Project' do
  let(:sf) { SfCli::Sf.new }
  let(:project) { SfCli::Sf::Project.new(sf) }

  describe '#generate' do
    it "create a Salesforce DX project directory" do
      allow(sf).to receive(:exec).with(
        'project',
        :generate,
        flags:        {name: 'TestProject', template: nil, :"output-dir" => nil},
        switches:     {manifest: false},
        redirection:  :null_stderr
      )
      .and_return(generate_response)

      result = sf.project.generate 'TestProject'

      expect(result.output_dir).to eq '/foo/baz/bar'
      expect(result.files).to include 'TestProject/sfdx-project.json'
      expect(result.raw_output).to eq 'ROW OUTPUT INFORMATION OF COMMAND'
      expect(result.warnings).to be_empty

      expect(sf).to have_received :exec
    end

    context 'using option: output_dir' do
      it 'can create the project at paticular directory' do
        allow(sf).to receive(:exec).with(
          'project',
          :generate,
          flags:        {name: 'TestProject', template: nil, :"output-dir" => 'tmp'},
          switches:     {manifest: false},
          redirection:  :null_stderr
        )
        .and_return(generate_response output_dir: 'tmp')

        result = sf.project.generate 'TestProject', output_dir: 'tmp'

        expect(result.files).to include 'tmp/TestProject/sfdx-project.json'
        expect(sf).to have_received :exec
      end
    end

    context 'using option: template' do
      it 'can create with paticular template (standard, empty or analytics)' do
        allow(sf).to receive(:exec).with(
          'project',
          :generate,
          flags:        {name: 'TestProject', template: :empty, :"output-dir" => nil},
          switches:     {manifest: false},
          redirection:  :null_stderr
        )
        .and_return(generate_response)

        result = sf.project.generate 'TestProject', template: :empty
        expect(sf).to have_received :exec
      end
    end

    context 'using option: manifest' do
      it 'can generate manifest file (package.xml)' do
        allow(sf).to receive(:exec).with(
          'project',
          :generate,
          flags:        {name: 'TestProject', template: nil, :"output-dir" => nil},
          switches:     {manifest: true},
          redirection:  :null_stderr
        )
        .and_return(generate_response manifest: true)

        result = sf.project.generate 'TestProject', manifest: true

        expect(result.files).to include 'TestProject/manifest/package.xml'
        expect(sf).to have_received :exec
      end
    end

    context 'using all options' do
      it do
        allow(sf).to receive(:exec).with(
          'project',
          :generate,
          flags:        {name: 'TestProject', template: :empty, :"output-dir" => 'tmp'},
          switches:     {manifest: true},
          redirection:  :null_stderr
        )
        .and_return(generate_response manifest: true, output_dir: 'tmp')

        result = sf.project.generate 'TestProject', manifest: true, template: :empty, output_dir: 'tmp'

        expect(result.files).to include 'tmp/TestProject/manifest/package.xml'
        expect(sf).to have_received :exec
      end
    end
  end

  describe '#generate_manifest' do
    it "create the manifest file of Salesforce DX project with a paticular metadata name" do
      allow(sf).to receive(:exec).with(
        'project',
        'generate manifest',
        flags: {
          name:           nil,
          metadata:       'CustomObject',
          :"output-dir"   => nil,
          :"source-dir"   => nil,
          :"from-org"     => nil,
          :"api-version"  => nil,
        },
        switches:     {},
        redirection:  :null_stderr
      )
      .and_return(manifest_response)

      expect(project.generate_manifest metadata: %w[CustomObject]).to eq 'package.xml'
      expect(sf).to have_received :exec
    end

    example 'generating a manifest with paticular metadata types' do
      allow(sf).to receive(:exec).with(
        'project',
        'generate manifest',
        flags: {
          name:           nil,
          metadata:       'CustomObject Report',
          :"output-dir"   => nil,
          :"source-dir"   => nil,
          :"from-org"     => nil,
          :"api-version"  => nil,
        },
        switches:     {},
        redirection:  :null_stderr
      )
      .and_return(manifest_response)

      project.generate_manifest metadata: %w[CustomObject Report]
      expect(sf).to have_received :exec
    end

    context 'using option: name' do
      it 'can create a manifest file with paticular name' do
        allow(sf).to receive(:exec).with(
          'project',
          'generate manifest',
          flags: {
            name:           'hoge.xml',
            metadata:       'CustomObject',
            :"output-dir"   => nil,
            :"source-dir"   => nil,
            :"from-org"     => nil,
            :"api-version"  => nil,
          },
          switches:     {},
          redirection:  :null_stderr
        )
        .and_return(manifest_response name: 'hoge.xml')

        expect(project.generate_manifest name: 'hoge.xml', metadata: %w[CustomObject]).to eq 'hoge.xml'
        expect(sf).to have_received :exec
      end
    end

    context 'using option: output_dir' do
      it 'can create a manifest file at paticular directory' do
        allow(sf).to receive(:exec).with(
          'project',
          'generate manifest',
          flags: {
            name:           nil,
            metadata:       'CustomObject',
            :"output-dir"   => 'tmp',
            :"source-dir"   => nil,
            :"from-org"     => nil,
            :"api-version"  => nil,
          },
          switches:     {},
          redirection:  :null_stderr
        )
        .and_return(manifest_response output_dir: 'tmp')

        expect(project.generate_manifest output_dir: 'tmp', metadata: %w[CustomObject]).to eq 'tmp/package.xml'
        expect(sf).to have_received :exec
      end
    end

    context 'using option: from_org' do
      it 'can put all metadata types of paticular org into a manifest file' do
        allow(sf).to receive(:exec).with(
          'project',
          'generate manifest',
          flags: {
            name:           nil,
            metadata:       nil,
            :"output-dir"   => nil,
            :"source-dir"   => nil,
            :"from-org"     => :dev,
            :"api-version"  => nil,
          },
          switches:     {},
          redirection:  :null_stderr
        )
        .and_return(manifest_response)

        project.generate_manifest from_org: :dev
        expect(sf).to have_received :exec
      end
    end

    context 'using option: source_dir' do
      it 'can put all metadata types in paticular source directory into a manifest file' do
        allow(sf).to receive(:exec).with(
          'project',
          'generate manifest',
          flags: {
            name:           nil,
            metadata:       nil,
            :"output-dir"   => nil,
            :"source-dir"   => 'force-app',
            :"from-org"     => nil,
            :"api-version"  => nil,
          },
          switches:     {},
          redirection:  :null_stderr
        )
        .and_return(manifest_response)

        project.generate_manifest source_dir: 'force-app'
        expect(sf).to have_received :exec
      end
    end

    context 'using option: api_version' do
      it 'can set paticular API version in the manifest file' do
        allow(sf).to receive(:exec).with(
          'project',
          'generate manifest',
          flags: {
            name:           nil,
            metadata:       'CustomObject',
            :"output-dir"   => nil,
            :"source-dir"   => nil,
            :"from-org"     => nil,
            :"api-version"  => 61.0,
          },
          switches:     {},
          redirection:  :null_stderr
        )
        .and_return(manifest_response)

        project.generate_manifest metadata: %w[CustomObject], api_version: 61.0
        expect(sf).to have_received :exec
      end
    end
  end

  def generate_response(manifest: false, output_dir: nil)
    {
      "status" => 0,
      "result" => {
        "outputDir" => "/foo/baz/bar",
        "created" => (
          manifest ?
            [%(#{output_dir.nil? ? '' : %|#{output_dir}/|}TestProject/manifest/package.xml)] :
            [%(#{output_dir.nil? ? '' : %|#{output_dir}/|}TestProject/sfdx-project.json)]
        ),
        "rawOutput" => "ROW OUTPUT INFORMATION OF COMMAND"
      },
      "warnings" => []
    }
  end

  def manifest_response(name: 'package.xml', output_dir: nil)
    {
      "status" => 0,
      "result" => {
        "path" => "#{output_dir.nil? ? '' : %|#{output_dir}/|}#{name}",
        "name" => "#{name}"
      },
      "warnings" => []
    }
  end
end
