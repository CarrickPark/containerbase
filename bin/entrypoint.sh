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

	EXEC_COMMAND="$@"
else
    # run consul agent and consul template in addition to the command specified
	AGENT="/bin/consul agent -config-dir=/config -join=$CP_ORCHESTRATOR_PRIMARY_IP -encrypt=$CP_ORCHESTRATOR_ENCRYPT"
	#echo Running Agent: "$AGENT"

	# run agent in background
	/bin/bash -c "$AGENT" &

	EXEC_COMMAND="$@"
fi

## support up to 6 templated files or just execute the command directly
if [ -n "$CP_TEMPLATE_6" ]; then
	/bin/consul-template \
	  -template="${CP_TEMPLATE}" \
		-template="${CP_TEMPLATE_2}" \
		-template="${CP_TEMPLATE_3}" \
		-template="${CP_TEMPLATE_4}" \
		-template="${CP_TEMPLATE_5}" \
		-template="${CP_TEMPLATE_6}" \
		-exec="$EXEC_COMMAND"
elif [ -n "$CP_TEMPLATE_5" ]; then
	/bin/consul-template \
	  -template="${CP_TEMPLATE}" \
		-template="${CP_TEMPLATE_2}" \
		-template="${CP_TEMPLATE_3}" \
		-template="${CP_TEMPLATE_4}" \
		-template="${CP_TEMPLATE_5}" \
		-exec="$EXEC_COMMAND"
elif [ -n "$CP_TEMPLATE_4" ]; then
	/bin/consul-template \
	  -template="${CP_TEMPLATE}" \
		-template="${CP_TEMPLATE_2}" \
		-template="${CP_TEMPLATE_3}" \
		-template="${CP_TEMPLATE_4}" \
		-exec="$EXEC_COMMAND"
elif [ -n "$CP_TEMPLATE_3" ]; then
	/bin/consul-template \
	  -template="${CP_TEMPLATE}" \
		-template="${CP_TEMPLATE_2}" \
		-template="${CP_TEMPLATE_3}" \
		-exec="$EXEC_COMMAND"
elif [ -n "$CP_TEMPLATE_2" ]; then
	/bin/consul-template \
	  -template="${CP_TEMPLATE}" \
		-template="${CP_TEMPLATE_2}" \
		-exec="$EXEC_COMMAND"
elif [ -n "$CP_TEMPLATE" ]; then
	/bin/consul-template -template="${CP_TEMPLATE}" -exec="$EXEC_COMMAND"
else
	exec $EXEC_COMMAND
fi
