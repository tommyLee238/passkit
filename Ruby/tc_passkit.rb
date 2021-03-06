require 'json'
require 'pp'
require 'test/unit'
require './passkit.rb'
require './ts_ios7.rb'

$VERBOSE = true

class TestPassKit < Test::Unit::TestCase
  def setup
    h = JSON.parse IO.read "#{ENV['HOME']}/.passkit.json"
    @pk = PassKit.new(h['key'], h['secret'])
  end
  def test_authenticate
    h = JSON.parse @pk.authenticate
    assert h['success']
    assert h.has_key?('username')
  end
  def test_template_list
    h = JSON.parse @pk.template_list
    assert h['success']
    assert h.has_key?('templates')
  end
  def test_template_fieldnames
    templates = JSON.parse @pk.template_list
    templates['templates'].each do |t|
      h = JSON.parse @pk.template_fieldnames t
      assert h['success']
    end
  end
  def test_template_passes
    templates = JSON.parse @pk.template_list
    templates['templates'].each do |t|
      h = JSON.parse @pk.template_passes t
      assert h['success']
    end
  end
  def test_template_update
    j = JSON.parse @pk.template_update('test', {'textItem' => 'New Defaults'})
    assert j['success']
  end
end
