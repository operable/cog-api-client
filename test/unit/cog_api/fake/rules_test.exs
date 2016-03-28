defmodule CogApi.Fake.RulesTest do
  use CogApi.FakeCase

  alias CogApi.Fake.Client

  doctest CogApi.Fake.Rules

  describe "rule_index" do
    it "returns a list of rules" do
      command_name = "operable:bundle"
      matching_rule_text = "when command is #{command_name}"
      Client.rule_create(matching_rule_text, fake_endpoint)
      Client.rule_create("when command is something:else", fake_endpoint)

      [rule] = Client.rule_index(command_name, fake_endpoint) |> get_value

      assert present rule.id
      assert rule.rule == matching_rule_text
      assert rule.command == command_name
    end
  end

  describe "rule_create" do
    it "returns the created rule" do
      rule_text = "when command is operable:help must have operable:manage_commands"
      rule = rule_text |> Client.rule_create(fake_endpoint) |> get_value

      assert present rule.id
      assert rule.rule == rule_text
      assert rule.command == "operable:help"
    end

    context "when the rule is invalid" do
      it "returns the errors" do
        rule_text = "when command ERROR text operable:help"
        {:error, [error]} = rule_text |> Client.rule_create(fake_endpoint)

        assert error =~ "Invalid rule syntax"
      end
    end
  end

  describe "rule_delete" do
    it "returns :ok" do
      rule_text = "when command is operable:which must have operable:manage_commands"
      rule = rule_text |> Client.rule_create(fake_endpoint) |> get_value

      response = Client.rule_delete(rule.id, fake_endpoint)

      assert response == :ok
    end

    context "when the rule cannot be deleted" do
      it "returns an error" do
        {:error, [error]} = Client.rule_delete("NOT_REAL", fake_endpoint)

        assert error == "The rule could not be deleted"
      end
    end
  end
end
