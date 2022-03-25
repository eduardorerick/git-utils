#!/bin/bash


confirm() {
	returnValue=''
	read -r -p "${1:-Are you sure? [y/N]} " response
	case "$response" in 
		[yY][eE][sS]|[yY])
			returnValue="true"
			;;
		*)
			returnValue="false"
			;;
	esac
	echo "$returnValue"
}



git fetch
git checkout develop
git pull

for branch in "$@"

do
	git checkout "$branch";
	git merge develop

	CONFLICTS=$(git ls-files -u)

	if [ "$CONFLICTS" ] 	
	then

		echo "You want to resolve conflicts?"
		isToSolve=$( confirm )
		if [ "$isToSolve" == "true" ] 
		then
			echo "Continue the merge? (Resolve the conflicts first!)"
			isSolved=$( confirm )
			if [ "$isSolved" == "true" ]
			then
				git merge --continue
				git push
				echo "Merged successfully!"
			else
				exit

			fi
		else
			echo "Aborting the merge ..."
			git merge --abort
		fi

	else
		git push
   		echo "$branch merged and pushed successfully"

 	fi

done

