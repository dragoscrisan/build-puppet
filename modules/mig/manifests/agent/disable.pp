# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class mig::agent::disable {

    $mig_path = $::operatingsystem ? { /(CentOS|Ubuntu)/ => '/sbin/mig-agent', Darwin => '/usr/local/bin/mig-agent' }
    case $::operatingsystem {
        # We want to disable mig-agent on Linux and MacOS workers
        Ubuntu: {
            case $::operatingsystemrelease {
                16.04: {
                    # Kill mig agent service if mig-agent is running
                    exec {
                        'kill mig':
                            command   => "/bin/kill -9 $(${mig_path} -q=pid)",
                            subscribe => Package['mig-agent'],
                            notify    => Service['mig-agent'],
                            onlyif    => "/usr/bin/test `mig-agent -q=pid|wc -l` -eq 1"
                    }
                    # Stop the mig-agent service and disable it
                    service {
                        'mig-agent':
                            ensure   => stopped,
                            enable   => false,
                            provider => 'systemd'
                    }
                    # remove the package from the worker
                    package {'mig-agent':
                        ensure => absent
                    }
                    # Remove mig configuration file and keys
                    # Configuration file and keys are stored in /etc/mig directory
                    file {'/etc/mig':
                        ensure => absent,
                        force  => true,
                    }
                }
            }
        }
        Darwin: {
            # Kill the process, if mig-agent is running
            exec {
                'kill mig':
                    command => "/bin/kill -9 $(${mig_path} -q=pid)",
                    onlyif  => "/bin/test `mig-agent -q=pid|wc -l` -eq 1"
            } ->
            # Remove the dmg package
            file {'/var/db/.puppet_pkgdmg_installed_mig-agent-20180807-0.e8eb90a1.prod-x86_64.dmg':
                ensure => 'absent',
                force  => true,
            } ->
            # Remove mig configuration file and keys
            # Configuration file and keys are stored in /etc/mig directory
            file {'/etc/mig':
                ensure => absent,
                force  => true,
            }->
            # Remove executable
            file {"${mig_path}":
                ensure => 'absent'
            }
        }
    }
}
