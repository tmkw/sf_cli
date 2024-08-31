RSpec.describe 'SfCli::Sf::Project' do
  let(:sf) { instance_double 'SfCli::Sf::Core' }
  let(:project) { SfCli::Sf::Project::Core.new(sf) }

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
      .and_return(exec_output)

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
      .and_return(exec_output)

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
        .and_return(exec_output name: 'hoge.xml')

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
        .and_return(exec_output output_dir: 'tmp')

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
        .and_return(exec_output)

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
        .and_return(exec_output)

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
        .and_return(exec_output)

        project.generate_manifest metadata: %w[CustomObject], api_version: 61.0
        expect(sf).to have_received :exec
      end
    end
  end

  def exec_output(name: 'package.xml', output_dir: nil)
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
