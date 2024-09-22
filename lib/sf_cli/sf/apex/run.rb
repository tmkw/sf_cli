require 'tempfile'

module SfCli::Sf::Apex
  module Run
    #
    # Run apex code and returns its result.
    # If you don't specify the script file, it starts interactive mode.
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm#cli_reference_apex_run_unified CLI reference
    #
    # @param target_org [Symbol,String]
    #   an alias of paticular org, or username can be used.
    # @param file [String,#read]
    #   (1) path to a local file that contains Apex code. 
    #   (2) object that has #read method
    # @param api_version [Numeric]
    #   override the api version used for api requests made by this command
    #
    # @return [ApexResult] Apex execution result.
    #
    # @example Execute apex code in a file
    #   result = sf.apex.run file: "path/to/apex"
    #   result.success # true if the execution succeeds
    #   result.logs    # execution log
    #
    # @example StringIO is usable instead of file path
    #   require 'stringio'
    #
    #   pseudo_file = StringIO.new <<~EOS
    #     Account acc = [SELECT Id, Name FROM Account Limit 1];
    #     System.debug(acc.Name);
    #   EOS
    #
    #   sf.apex.run target_org: :dev, file: pseudo_file
    #
    # @example Interactive Mode
    #   irb(main:) > sf.apex.run target_org: :dev
    #
    #   Account acc = [SELECT Id, Name FROM Account LIMIT 1];
    #   System.debug(acc.Name);
    #   <press Ctrl-D>
    #
    #   =>
    #   #<SfCli::Sf::Apex::Run::ApexResult:0x00007437b4e13218
    #     @column=-1,
    #     @compile_problem="",
    #     @compiled=true,
    #     @exception_message="",
    #     @exception_stack_trace="",
    #     @line=-1,
    #     @logs=
    #      ["61.0 APEX_CODE,DEBUG;APEX_PROFILING,INFO",
    #       "Execute Anonymous: Account acc = [SELECT Id, Name FROM Account LIMIT 1];",
    #       "Execute Anonymous: System.debug(acc.Name);",
    #      ....]
    #
    def run(target_org: nil, file: nil, api_version: nil)
      _file = crate_tmpfile(file)
      path = _file&.path || file
      flags = {:"target-org" => target_org, :"file" => path, :"api-version" => api_version}

      json = exec(__method__, flags: flags, redirection: :null_stderr)
      ApexResult.new(json['result'])
    ensure
      _file&.close!
    end

    private

    def crate_tmpfile(path_or_io)
      return create_tmpfile_by_user_input if path_or_io.nil?
      create_tmpfile_by_io(path_or_io)
    end

    def create_tmpfile_by_user_input
      Tempfile.open(%w[sf apex]) do |f|
        s = $stdin.gets
        while s
          f.puts(s)
          s = $stdin.gets
        end
        f
      end
    end

    class ApexResult
      attr_reader :success, :compiled, :compile_problem, :exception_message, :exception_stack_trace, :line, :column, :logs

      def initialize(attributes)
        @success = attributes['success']
        @compiled = attributes['compiled']
        @compile_problem = attributes['compileProblem']
        @exception_message = attributes['exceptionMessage']
        @exception_stack_trace = attributes['exceptionStackTrace']
        @line = attributes['line']
        @column = attributes['column']
        @logs = attributes['logs'].chomp.split("\n")
      end
    end
  end
end
