#!/bin/bash

# Save the current directory
current_dir=$(pwd)
script_dir=$(dirname "$0")

# Check if a parameter is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a name for the main folder."
  exit 1
fi

# Create mail folder
mkdir "$1"

# Create subfolders
mkdir "$1/routes"
mkdir "$1/controllers"
mkdir "$1/services"
mkdir "$1/utils"
mkdir "$1/public"

# Create index.js file
touch "$1/index.js"

# Change directory to the custom folder
cd "$1" || exit

# Initialize npm and git
npm init -y
git init

# Create .env file
touch .env

# Navigate to the directory where the script resides
cd "$script_dir" || exit

# Search for the template_gitignore file recursively starting from the current directory
template_gitignore_path=$(find . -type f -name "template_gitignore" -print -quit)

# Check if the template_gitignore file was found
if [ -n "$template_gitignore_path" ]; then
    # Copy the template_gitignore file to the current directory
    cd "$current_dir" || exit
    cd "$1" || exit
    cp "$script_dir/$template_gitignore_path" ./.gitignore
else
    echo "Error: template_gitignore file not found."
fi

# Navigate to the directory where the script resides
cd "$(dirname "$0")" || exit

# Search for the template_package.json file recursively starting from the current directory
template_package_json_path=$(find . -type f -name "template_package.json" -print -quit)

# Check if the template_package.json file was found
if [ -n "$template_package_json_path" ]; then
    # Copy the template_package.json file to the current directory
    cd "$current_dir" || exit
    cd "$1" || exit
    cp "$script_dir/$template_package_json_path" ./package.json
else
    echo "Error: template_package.json file not found."
fi

# Update package.json with the new name
sed -i 's/"name": "server"/"name": "@server\/'"$1"'"/' package.json

# Install dependencies
npm i -E express dotenv cors helmet jsonwebtoken bcryptjs cookie-parser body-parser
npm i -DE nodemon morgan standard

# Prompt for installing eslint
read -r -p "Do you want to install eslint? (y/n): " install_eslint
if [[ $install_eslint =~ ^[Yy]$ ]]; then
  npm i -DE eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard

  # Search for the template_eslintrc.json file recursively starting from the current directory
  template_eslintrc_json_path=$(find . -type f -name "template_eslintrc.json" -print -quit)

  # Check if the template_eslintrc.json file was found
  if [ -n "$template_eslintrc_json_path" ]; then
      # Copy the template_eslintrc.json file to the current directory
      cd "$current_dir" || exit
      cd "$1" || exit
      cp "$script_dir/$template_eslintrc_json_path" ./.eslintrc.json
  else
      echo "Error: template_eslintrc.json file not found."
  fi
fi

# Prompt for installing mongoose
read -r -p "Do you want to install mongoose? (y/n): " install_mongoose
if [[ $install_mongoose =~ ^[Yy]$ ]]; then
  npm i -E mongoose
  mkdir db
  mkdir db/config db/models
fi

# Prompt for installing prisma if mongoose is not installed
if [ ! -z "$install_mongoose" ] && [[ ! $install_mongoose =~ ^[Yy]$ ]]; then
  read -r -p "Do you want to install prisma? (y/n): " install_prisma
  if [[ $install_prisma =~ ^[Yy]$ ]]; then
    npm i -E prisma
    mkdir db
    mkdir db/config db/models
  fi
fi

# Prompt for choosing between CommonJS and ES modules
read -r -p "Do you want to use CommonJS (1/cjs) or ES modules (2/esm)? " module_choice

# Check the user's choice and update package.json and .eslintrc.json accordingly
case "$module_choice" in
    1|cjs)
        sed -i 's/"type": "module"/"type": "commonjs"/' package.json
        sed -i 's/"sourceType": "module"/"sourceType": "commonjs"/' .eslintrc.json
        ;;
    2|esm)
        sed -i 's/"type": "commonjs"/"type": "module"/' package.json
        sed -i 's/"sourceType": "commonjs"/"sourceType": "module"/' .eslintrc.json
        ;;
    *)
        echo "Error: Invalid choice. Please choose either '1' or 'cjs' for CommonJS, or '2' or 'esm' for ES modules."
        exit 1
        ;;
esac

# Creating a simple README.md file
echo '# '"$1" > README.md
echo 'type *npm run dev* for starting the developing mode' >> README.md

# Display success message
echo "Setup completed successfully!"

# Prompt for starting coding
read -r -p "Do you want to start coding now? (y/n): " start_coding
if [[ $start_coding =~ ^[Yy]$ ]]; then
  code .
fi
