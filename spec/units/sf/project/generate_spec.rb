RSpec.describe 'SfCli::Sf::Project' do
  let(:project) { SfCli::Sf::Project::Core.new }

  describe '#generate' do
    it "create a Salesforce DX project directory" do
      allow(project).to receive(:exec).with(
        :generate,
        flags:        {name: 'TestProject', template: nil, :"output-dir" => nil},
        switches:     {manifest: false},
        redirection:  :null_stderr,
        raw_output:   false,
        format:       :json
      )
      .and_return(exec_output)

      result = project.generate 'TestProject'

      expect(result.output_dir).to eq '/foo/baz/bar'
      expect(result.files).to include 'TestProject/sfdx-project.json'
      expect(result.raw_output).to eq 'ROW OUTPUT INFORMATION OF COMMAND'
      expect(result.warnings).to be_empty

      expect(project).to have_received :exec
    end

    context 'using option: output_dir' do
      it 'can create the project at paticular directory' do
        allow(project).to receive(:exec).with(
          :generate,
          flags:        {name: 'TestProject', template: nil, :"output-dir" => 'tmp'},
          switches:     {manifest: false},
          redirection:  :null_stderr,
          raw_output:   false,
          format:       :json
        )
        .and_return(exec_output output_dir: 'tmp')

        result = project.generate 'TestProject', output_dir: 'tmp'

        expect(result.files).to include 'tmp/TestProject/sfdx-project.json'
        expect(project).to have_received :exec
      end
    end

    context 'using option: template' do
      it 'can create with paticular template (standard, empty or analytics)' do
        allow(project).to receive(:exec).with(
          :generate,
          flags:        {name: 'TestProject', template: :empty, :"output-dir" => nil},
          switches:     {manifest: false},
          redirection:  :null_stderr,
          raw_output:   false,
          format:       :json
        )
        .and_return(exec_output)

        result = project.generate 'TestProject', template: :empty
        expect(project).to have_received :exec
      end
    end

    context 'using option: manifest' do
      it 'can generate manifest file (package.xml)' do
        allow(project).to receive(:exec).with(
          :generate,
          flags:        {name: 'TestProject', template: nil, :"output-dir" => nil},
          switches:     {manifest: true},
          redirection:  :null_stderr,
          raw_output:   false,
          format:       :json
        )
        .and_return(exec_output manifest: true)

        result = project.generate 'TestProject', manifest: true

        expect(result.files).to include 'TestProject/manifest/package.xml'
        expect(project).to have_received :exec
      end
    end

    context 'using all options' do
      it do
        allow(project).to receive(:exec).with(
          :generate,
          flags:        {name: 'TestProject', template: :empty, :"output-dir" => 'tmp'},
          switches:     {manifest: true},
          redirection:  :null_stderr,
          raw_output:   false,
          format:       :json
        )
        .and_return(exec_output manifest: true, output_dir: 'tmp')

        result = project.generate 'TestProject', manifest: true, template: :empty, output_dir: 'tmp'

        expect(result.files).to include 'tmp/TestProject/manifest/package.xml'
        expect(project).to have_received :exec
      end
    end
  end

  def exec_output(manifest: false, output_dir: nil)
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
end
