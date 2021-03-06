#
# Cookbook Name:: contrail
# Library:: utils
#
# Copyright 2014, Juniper Networks
#

def get_all_roles_nodes
    result = search(:node, "chef_environment:#{node.chef_environment}")
    if result.any? { |x| x['hostname'] == node['hostname'] }
        result.map! { |x| x['hostname'] == node['hostname'] ? node : x }
    else
        result.push(node)
    end
    return result.sort! { |a, b| a['hostname'] <=> b['hostname'] }
end

def get_database_nodes
    result = search(:node, "role:*contrail-database* AND chef_environment:#{node.chef_environment}")
    result.map! { |x| x['hostname'] == node['hostname'] ? node : x }
    if not result.include?(node) and node.run_list.roles.include?('contrail-database')
        result.push(node)
    end
    result.each { |node| node.default['contrail']['node_number'] = "#{result.rindex(node)+1}" }
    return result.sort! { |a, b| a['hostname'] <=> b['hostname'] }
end

def get_config_nodes
    result = search(:node, "role:*config* AND chef_environment:#{node.chef_environment}")
    result.map! { |x| x['hostname'] == node['hostname'] ? node : x }
    if not result.include?(node) and node.run_list.roles.include?('config')
        result.push(node)
    end
    return result.sort! { |a, b| a['hostname'] <=> b['hostname'] }
end

def get_compute_nodes
    result = search(:node, "role:*compute* AND chef_environment:#{node.chef_environment}")
    result.map! { |x| x['hostname'] == node['hostname'] ? node : x }
    if not result.include?(node) and node.run_list.roles.include?('compute')
        result.push(node)
    end
    return result.sort! { |a, b| a['hostname'] <=> b['hostname'] }
end
