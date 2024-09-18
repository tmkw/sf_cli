require 'tempfile'
require 'stringio'

module SfCli::Sf::Apex
  module Run
    #
    # run apex code and returns its result
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # *file* --- (1) path to a local file that contains \Apex code. (2) StringIO object
    #
    # == Examples
    # Execute apex code in a file
    #   result = sf.apex.run file: "path/to/apex"
    #   result.success # true if the execution succeeds
    #   result.logs    # execution log
    #
    # StringIO is usable instead of file path
    #   require 'stringio'
    #
    #   pseudo_file = StringIO.new <<~EOS
    #     Account acc = [SELECT Id, Name FROM Account Limit 1];
    #     System.debug(acc.Name);
    #   EOS
    #
    #   sf.apex.run target_org: :dev, file: pseudo_file
    #
    # == Interactive Mode
    #
    # If you don't specify *file* argument, it starts interactive mode that may be helpful in IRB environment.
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
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm#cli_reference_apex_run_unified]
    #
    def run(target_org: nil, file: nil)
      return run_interactive(target_org) if file.nil?
      return run_by_io(target_org, file) if file.is_a? StringIO

      return unless file.is_a? String

      flags = {:"target-org" => target_org, :"file" => file}

      json = exec(__method__, flags: flags, redirection: :null_stderr)
      ApexResult.new(json['result'])
    end

    private

    def run_by_io(target_org, io)
      file = Tempfile.open(%w[sf apex]){|f| f.write(io.read); f}

      flags = {:"target-org" => target_org, :"file" => file.path}
      json = exec(:run, flags: flags, redirection: :null_stderr)
      ApexResult.new(json['result'])
    ensure
      file&.close!
    end

    def run_interactive(target_org)
      file = Tempfile.open(%w[sf apex]) do |f|
               s = $stdin.gets
               while s
                 f.puts(s)
                 s = $stdin.gets
               end
               f
             end

      flags = {:"target-org" => target_org, :"file" => file.path}

      json = exec(:run, flags: flags, redirection: :null_stderr)
      ApexResult.new(json['result'])
    ensure
      file&.close!
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
