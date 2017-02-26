require "cli"
require "commands/configure"

RSpec.describe CLI do
  def run_command(name, mock, args)
    config = {
      shell: Thor::Base.shell.new,
      commands: Hash[name, double(new: mock)]
    }
    described_class.send(:dispatch, nil, args, nil, config)
  end

  describe "configure" do
    let(:command) { instance_double("Commands::Configure") }
    it "runs the Configure command" do
      args = ["configure"]
      expect(command).to receive(:run).with(no_args)

      run_command :configure, command, args
    end
  end

  describe "color" do
    let(:command) { instance_double("Commands::Color") }
    it "returns an error with a missing argument" do
      args = ["color"]
      expect { run_command :configure, command, args }.
        to raise_error(Thor::InvocationError, /called with no arguments/)
    end
    it "passes the color to the Color command" do
      args = ["color", "green"]
      expect(command).to receive(:run).with("green")

      run_command :color, command, args
    end
  end
end

