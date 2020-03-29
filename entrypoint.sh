#!/bin/sh

REPOS_DIR=/git-server/repos

print_message() {
    echo "## $1"
}

print_message "Setting up repositories..."

for REPO in `env | awk -F= '/^REPO_/ {print $2}'`
do
    echo
    print_message "Creating repository $REPO"
    git init --bare $REPOS_DIR/$REPO

    if [ -d /hooks/$REPO ]
    then
        print_message "Copying custom server-side hooks for $REPO:"
        chmod -R +x /hooks/$REPO/
        cp -va /hooks/$REPO/. $REPOS_DIR/$REPO/hooks/
    else
        print_message "No custom server-side hooks provided for repository $REPO"
    fi
done

# run a custom setup script if we have one
if [ -f /custom-setup.sh ]
then
    echo
    print_message "Running custom setup script...
    chmod +x /custom-setup.sh
    /custom-setup.sh
fi

exec "$@"
