# frozen_string_literal: true

require "json"

module VirtualKeys
  VK1 = "vk1"
  VK2 = "vk2"
  VK3 = "vk3"
end

module BundleIdentifiers
  ITERM2 = "com.googlecode.iterm2"
end

module Values
  ON = 1
  OFF = 0
end

module Conditions
  WITH_VK1 = {type: "variable_if", name: VirtualKeys::VK1, value: Values::ON}
  WITH_VK2 = {type: "variable_if", name: VirtualKeys::VK2, value: Values::ON}
  WITH_VK3 = {type: "variable_if", name: VirtualKeys::VK3, value: Values::ON}

  ON_ITERM2 = {type: "frontmost_application_if", bundle_identifiers: [BundleIdentifiers::ITERM2]}
end

class Array
  def basic
    map! { |h| { type: "basic" }.merge!(h) }
  end

  def vk1
    map! { |h| {conditions: [Conditions::WITH_VK1]}.merge!(h) }
  end

  def vk2
    map! { |h| {conditions: [Conditions::WITH_VK2]}.merge!(h) }
  end

  def vk3
    map! { |h| {conditions: [Conditions::WITH_VK3]}.merge!(h) }
  end

  def iterm2_vk1
    map! { |h| {conditions: [Conditions::ON_ITERM2, Conditions::WITH_VK1]}.merge!(h) }
  end
end

puts ({
  title: "Personal rules (@hioki-daichi)",
  rules: [
    {
      description: "lang1/international4 -> VK1",
      manipulators: ["lang1", "international4"].map! do |key_code|
        {
          from: { key_code: key_code },
          to: [{set_variable: {name: VirtualKeys::VK1, value: Values::ON}}],
          to_after_key_up: [{set_variable: {name: VirtualKeys::VK1, value: Values::OFF}}],
        }
      end.basic,
    },
    {
      description: "lang2/international5 -> VK2",
      manipulators: ["lang2", "international5"].map! do |key_code|
        {
          from: { key_code: key_code },
          to: [{set_variable: {name: VirtualKeys::VK2, value: Values::ON}}],
          to_after_key_up: [{set_variable: {name: VirtualKeys::VK2, value: Values::OFF}}],
        }
      end.basic,
    },
    {
      description: "international2 -> VK3",
      manipulators: ["international2"].map! do |key_code|
        {
          from: { key_code: key_code },
          to: [{set_variable: {name: VirtualKeys::VK3, value: Values::ON}}],
          to_after_key_up: [{set_variable: {name: VirtualKeys::VK3, value: Values::OFF}}],
        }
      end.basic,
    },
    {
      description: "[iTerm2] o/p -> control+t control+p / control+t control+n",
      manipulators: [
        {from: { key_code: "o" }, to: [{key_code: "t", modifiers: ["control"]}, {key_code: "p", modifiers: ["control"]}]},
        {from: { key_code: "p" }, to: [{key_code: "t", modifiers: ["control"]}, {key_code: "n", modifiers: ["control"]}]},
      ].iterm2_vk1.basic,
    },
    {
      description: "[iTerm2] z/y -> copy and paste",
      manipulators: [
        {from: { key_code: "z" }, to: [{key_code: "t", modifiers: ["control"]}, {key_code: "close_bracket", modifiers: ["control"]}]},
        {from: { key_code: "y" }, to: [{ key_code: "return_or_enter" }, {key_code: "t", modifiers: ["control"]}, {key_code: "m", modifiers: ["control"]}]},
      ].iterm2_vk1.basic,
    },
    {
      description: "[iTerm2] u/i -> shift+0 / shift+4",
      manipulators: [
        {from: { key_code: "u" }, to: [{key_code: "0", modifiers: ["shift"]}]},
        {from: { key_code: "i" }, to: [{key_code: "4", modifiers: ["shift"]}]},
      ].iterm2_vk1.basic,
    },
    {
      description: "[VK1] h/j/k/l -> cursor move",
      manipulators: [
        {from: {key_code: "h", modifiers: {optional: ["any"]}}, to: [{ key_code: "left_arrow" }]},
        {from: {key_code: "j", modifiers: {optional: ["any"]}}, to: [{ key_code: "down_arrow" }]},
        {from: {key_code: "k", modifiers: {optional: ["any"]}}, to: [{ key_code: "up_arrow" }]},
        {from: {key_code: "l", modifiers: {optional: ["any"]}}, to: [{ key_code: "right_arrow" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] f -> escape",
      manipulators: [
        {from: { key_code: "f" }, to: [{ key_code: "escape" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] s/d -> shift+control+j/shift+control+; (Google Japanese Input)",
      manipulators: [
        {from: { key_code: "s" }, to: [{key_code: "j", modifiers: ["shift", "control"]}]},
        {from: { key_code: "d" }, to: [{key_code: "semicolon", modifiers: ["shift", "control"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] a/z -> f10/f7",
      manipulators: [
        {from: { key_code: "a" }, to: [{ key_code: "f10" }]},
        {from: { key_code: "z" }, to: [{ key_code: "f7" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] u/i -> command+left/command+right",
      manipulators: [
        {from: {key_code: "u", modifiers: {optional: ["any"]}}, to: [{key_code: "left_arrow", modifiers: ["command"]}]},
        {from: {key_code: "i", modifiers: {optional: ["any"]}}, to: [{key_code: "right_arrow", modifiers: ["command"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] g -> tab",
      manipulators: [
        {from: {key_code: "g", modifiers: {optional: ["any"]}}, to: [{ key_code: "tab" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] o/p -> control+shift+tab/control+tab",
      manipulators: [
        {from: { key_code: "o" }, to: [{key_code: "tab", modifiers: ["control", "shift"]}]},
        {from: { key_code: "p" }, to: [{key_code: "tab", modifiers: ["control"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] y/t/x -> command+c/command+x/command+shift+v",
      manipulators: [
        {from: { key_code: "y" }, to: [{key_code: "c", modifiers: ["command"]}]},
        {from: { key_code: "t" }, to: [{key_code: "x", modifiers: ["command"]}]},
        {from: { key_code: "x" }, to: [{key_code: "v", modifiers: ["command", "shift"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] c/e -> backspace/delete",
      manipulators: [
        {from: { key_code: "c" }, to: [{ key_code: "delete_or_backspace" }]},
        {from: { key_code: "e" }, to: [{ key_code: "delete_forward" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] [ -> command+z",
      manipulators: [
        {from: { key_code: "close_bracket" }, to: [{key_code: "z", modifiers: ["command"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] colon -> command+h",
      manipulators: [
        {from: { key_code: "quote" }, to: [{key_code: "h", modifiers: ["command"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] n/m/comma/dot -> mouse move",
      manipulators: [
        {from: {key_code: "n", modifiers: {mandatory: ["shift"]}}, to: [{mouse_key: {x: -1536}}]},
        {from: {key_code: "m", modifiers: {mandatory: ["shift"]}}, to: [{ mouse_key: { y: 1536 } }]},
        {from: {key_code: "comma", modifiers: {mandatory: ["shift"]}}, to: [{mouse_key: {y: -1536}}]},
        {from: {key_code: "period", modifiers: {mandatory: ["shift"]}}, to: [{ mouse_key: { x: 1536 } }]},
        {from: { key_code: "n" }, to: [{mouse_key: {x: -3072}}]},
        {from: { key_code: "m" }, to: [{ mouse_key: { y: 3072 } }]},
        {from: { key_code: "comma" }, to: [{mouse_key: {y: -3072}}]},
        {from: { key_code: "period" }, to: [{ mouse_key: { x: 3072 } }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] / -> mouse click",
      manipulators: [
        {from: {key_code: "slash", modifiers: {optional: ["any"]}}, to: [{ pointing_button: "button1" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] @/] -> scroll",
      manipulators: [
        {from: { key_code: "open_bracket" }, to: [{mouse_key: {vertical_wheel: -64}}]},
        {from: { key_code: "non_us_pound" }, to: [{ mouse_key: { vertical_wheel: 64 } }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] numbers -> function keys",
      manipulators: [
        {from: { key_code: "1" }, to: [{ key_code: "f1" }]},
        {from: { key_code: "2" }, to: [{ key_code: "f2" }]},
        {from: { key_code: "3" }, to: [{ key_code: "f3" }]},
        {from: { key_code: "4" }, to: [{ key_code: "f4" }]},
        {from: { key_code: "5" }, to: [{ key_code: "f5" }]},
        {from: { key_code: "6" }, to: [{ key_code: "f6" }]},
        {from: { key_code: "7" }, to: [{ key_code: "f7" }]},
        {from: { key_code: "8" }, to: [{ key_code: "f8" }]},
        {from: { key_code: "9" }, to: [{ key_code: "f9" }]},
        {from: { key_code: "0" }, to: [{ key_code: "f10" }]},
        {from: { key_code: "hyphen" }, to: [{ key_code: "f11" }]},
        {from: { key_code: "equal_sign" }, to: [{ key_code: "f12" }]},
      ].vk1.basic,
    },
    {
      description: "[VK1] b -> window maximize (ShiftIt)",
      manipulators: [
        {from: { key_code: "b" }, to: [{key_code: "m", modifiers: ["control", "option", "command"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK1] w -> command+w",
      manipulators: [
        {from: { key_code: "w" }, to: [{key_code: "w", modifiers: ["command"]}]},
      ].vk1.basic,
    },
    {
      description: "[VK2] f/d/s/a -> command+tab/command+shift+tab",
      manipulators: [
        {from: { key_code: "f" }, to: [{key_code: "tab", modifiers: ["command"]}]},
        {from: { key_code: "d" }, to: [{key_code: "tab", modifiers: ["command"]}]},
        {from: { key_code: "s" }, to: [{key_code: "tab", modifiers: ["command", "shift"]}]},
        {from: { key_code: "a" }, to: [{key_code: "tab", modifiers: ["command", "shift"]}]},
      ].vk2.basic,
    },
    {
      description: "[VK2] 9/0 -> command+shift+;/command+hyphen",
      manipulators: [
        {from: { key_code: "9" }, to: [{key_code: "semicolon", modifiers: ["command", "shift"]}]},
        {from: { key_code: "0" }, to: [{key_code: "hyphen", modifiers: ["command"]}]},
      ].vk2.basic,
    },
    {
      description: "[VK2] 1/2 -> volume decrement/increment",
      manipulators: [
        {from: { key_code: "1" }, to: [{ key_code: "volume_decrement" }]},
        {from: { key_code: "2" }, to: [{ key_code: "volume_increment" }]},
      ].vk2.basic,
    },
    {
      description: "[VK2] 3/4 -> display brightness decrement/increment",
      manipulators: [
        {from: { key_code: "3" }, to: [{ key_code: "display_brightness_decrement" }]},
        {from: { key_code: "4" }, to: [{ key_code: "display_brightness_increment" }]},
      ].vk2.basic,
    },
    {
      description: "[VK2] ShiftIt",
      manipulators: [
        {from: { key_code: "h" }, to: [{key_code: "left_arrow", modifiers: ["command", "control", "option"]}]},
        {from: { key_code: "o" }, to: [{key_code: "right_arrow", modifiers: ["command", "control", "option"]}]},
        {from: { key_code: "n" }, to: [{key_code: "down_arrow", modifiers: ["command", "control", "option"]}]},
        {from: { key_code: "p" }, to: [{key_code: "up_arrow", modifiers: ["command", "control", "option"]}]},
        {from: { key_code: "u" }, to: [{key_code: "1", modifiers: ["control", "option", "command"]}]},
        {from: { key_code: "i" }, to: [{key_code: "2", modifiers: ["control", "option", "command"]}]},
        {from: {key_code: "m", modifiers: []}, to: [{key_code: "3", modifiers: ["control", "option", "command"]}]},
        {from: { key_code: "comma" }, to: [{key_code: "4", modifiers: ["control", "option", "command"]}]},
      ].vk2.basic,
    },
    {
      description: "[VK2] j -> Google Chrome.app",
      manipulators: [
        {
          from: { key_code: "j" },
          to: [{ shell_command: "open -a 'Google Chrome.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] k -> iTerm.app",
      manipulators: [
        {
          from: { key_code: "k" },
          to: [{ shell_command: "open -a 'iTerm.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] l -> Alfred 3.app",
      manipulators: [
        {
          from: { key_code: "l" },
          to: [{ shell_command: "open -a 'Alfred 3.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] / -> Slack.app",
      manipulators: [
        {
          from: { key_code: "slash" },
          to: [{ shell_command: "open -a 'Slack.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] @ -> Mail.app",
      manipulators: [
        {
          from: { key_code: "open_bracket" },
          to: [{ shell_command: "open -a 'Mail.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] : -> Visual Studio Code.app",
      manipulators: [
        {
          from: { key_code: "quote" },
          to: [{ shell_command: "open -a 'Visual Studio Code.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] t -> Things.app",
      manipulators: [
        {
          from: { key_code: "t" },
          to: [{ shell_command: "open -a 'Things.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] b -> Tweetbot.app",
      manipulators: [
        {
          from: { key_code: "b" },
          to: [{ shell_command: "open -a 'Tweetbot.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] . -> Skim.app",
      manipulators: [
        {
          from: { key_code: "period" },
          to: [{ shell_command: "open -a 'Skim.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK2] r -> Notes.app",
      manipulators: [
        {
          from: { key_code: "r" },
          to: [{ shell_command: "open -a 'Notes.app'" }],
        },
      ].vk2.basic,
    },
    {
      description: "[VK3] a/s/d/f/g/h/j/k/l/;/: -> 1/2/3/4/5/6/7/8/9/0/-",
      manipulators: [
        {from: { key_code: "a" }, to: [{ key_code: "1" }]},
        {from: { key_code: "s" }, to: [{ key_code: "2" }]},
        {from: { key_code: "d" }, to: [{ key_code: "3" }]},
        {from: { key_code: "f" }, to: [{ key_code: "4" }]},
        {from: { key_code: "g" }, to: [{ key_code: "5" }]},
        {from: { key_code: "h" }, to: [{ key_code: "6" }]},
        {from: { key_code: "j" }, to: [{ key_code: "7" }]},
        {from: { key_code: "k" }, to: [{ key_code: "8" }]},
        {from: { key_code: "l" }, to: [{ key_code: "9" }]},
        {from: { key_code: "semicolon" }, to: [{ key_code: "0" }]},
        {from: { key_code: "quote" }, to: [{ key_code: "hyphen" }]},
      ].vk3.basic,
    },
    {
      description: "; -> enter",
      manipulators: [
        {from: {key_code: "semicolon", modifiers: {mandatory: ["control"]}}, to: [{ key_code: "semicolon" }]},
        {from: {key_code: "semicolon", modifiers: {mandatory: ["shift"]}}, to: [{key_code: "semicolon", modifiers: ["shift"]}]},
        {from: {key_code: "semicolon", modifiers: {optional: ["any"]}}, to: [{ key_code: "return_or_enter" }]},
      ].basic,
    },
    {
      description: "control+: -> '",
      manipulators: [
        {from: {key_code: "colon", modifiers: {mandatory: ["control"]}}, to: [{key_code: "7", modifiers: ["shift"]}]},
      ].basic,
    },
  ],
}).to_json
