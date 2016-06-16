defmodule CogApi.HTTP.RulesTest do
  use CogApi.HTTPCase

  alias CogApi.HTTP.Client

  doctest CogApi.HTTP.Rules

  describe "rule_index" do
    it "returns a list of rules" do
      cassette "rule_index" do
        command_name = "operable:bundle"
        rules = command_name |> Client.rule_index(valid_endpoint) |> get_value

        first_rule = List.first rules
        assert present first_rule.id
        assert present first_rule.rule
        assert first_rule.command == command_name
      end
    end

    context "when the command does not have a rule" do
      it "returns an empty list" do
        cassette "rule_index_without_rule_for_command" do
          command_name = "operable:raw"
          rules = command_name |> Client.rule_index(valid_endpoint) |> get_value

          assert length(rules) == 0
        end
      end
    end
  end

  describe "rule_create" do
    it "returns the created rule" do
      cassette "rule_create" do
        bundle = Client.bundle_show_by_name(valid_endpoint, "operable") |> get_value 
        bundle_version_id = bundle.enabled_version.id
        rule_text = "when command is operable:help must have operable:manage_commands"
        rule = Client.rule_create(bundle_version_id, rule_text, valid_endpoint) |> get_value

        assert present rule.id
        assert rule.rule == rule_text
      end
    end

    context "when the rule is invalid" do
      it "returns the errors" do
        cassette "rule_create_invalid" do
          bundle = Client.bundle_show_by_name(valid_endpoint, "operable") |> get_value 
          bundle_version_id = bundle.enabled_version.id
          rule_text = "when command invalid text operable:help"
          {:error, [error]} = Client.rule_create(bundle_version_id, rule_text, valid_endpoint)

          assert error =~ "Invalid rule syntax"
        end
      end
    end
  end

  describe "rule_delete" do
    it "returns :ok" do
      cassette "rule_delete" do
        endpoint = valid_endpoint
        bundle = Client.bundle_show_by_name(valid_endpoint, "operable") |> get_value 
        bundle_version_id = bundle.enabled_version.id
        rule_text = "when command is operable:which must have operable:manage_commands"
        rule = Client.rule_create(bundle_version_id, rule_text, valid_endpoint) |> get_value

        response = Client.rule_delete(rule.id, endpoint)

        assert response == :ok
      end
    end

    context "when the rule cannot be deleted" do
      it "returns an error" do
        cassette "rule_delete_invalid" do
          {:error, [error]} = Client.rule_delete("NOT_REAL", valid_endpoint)

          assert error == "The rule could not be deleted"
        end
      end
    end
  end
end
