#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	# command starts with dash so it must be options for consul agent
	if [ "$CP_ORCHESTRATOR_PRIMARY_IP" != "" ]; then
		# when primary ip is present then we need to join primary
		set -- /bin/consul agent -config-dir=/config -join=$CP_ORCHESTRATOR_PRIMARY_IP -encrypt=$CP_ORCHESTRATOR_ENCRYPT "$@"
	else
		# when no primary ip is present then we are primary
		set -- /bin/consul agent -config-dir=/config -encrypt=$CP_ORCHESTRATOR_ENCRYPT "$@"
	fi
else
    # run consul agent in addition to the command specified
	AGENT="/bin/consul agent -config-dir=/config -join=$CP_ORCHESTRATOR_PRIMARY_IP -encrypt=$CP_ORCHESTRATOR_ENCRYPT"
	#echo Running Agent: "$AGENT"
	
	# run in background
	/bin/bash -c "$AGENT" &
fi

#echo Running Command: "$@"
exec "$@"
