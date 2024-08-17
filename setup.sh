#!/bin/bash

# Save the current directory
current_dir=$(pwd)
script_dir=$(dirname "$0")

# Check if a parameter is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a name for the main folder."
  exit 1
fi

# Create main folder and subfolders
mkdir -p "$1/src/config" "$1/src/models" "$1/src/routes" "$1/src/controllers" "$1/src/tests" "$1/src/middlewares" "$1/src/services" "$1/src/utils" "$1/public"

# Create index.js file
touch "$1/index.js" "$1/src/config/constants.js" "$1/src/config/db.js" "$1/src/server.js" "$1/src/routes/.gitkeep" "$1/src/controllers/.gitkeep" "$1/src/middlewares/.gitkeep" "$1/src/services/.gitkeep" "$1/src/utils/.gitkeep" "$1/src/utils/logger.js" "$1/src/utils/response.js" "$1/src/utils/validation.js"

# Change directory to the custom folder
cd "$1" || exit

# Initialize npm and git
npm init -y
git init

# Create .env file
echo -e "BASE_URL=http://localhost\nPORT=3000" > .env

# Check and copy .gitignore template
if [ -f "$script_dir/template_gitignore" ]; then
  cp "$script_dir/template_gitignore" ./.gitignore
else
  echo "Error: template_gitignore file not found."
fi

# Check and copy package.json template
if [ -f "$script_dir/template_package.json" ]; then
  cp "$script_dir/template_package.json" ./package.json
else
  echo "Error: template_package.json file not found."
fi

# Update package.json with the new name
sed -i "s/\"name\": \"server\"/\"name\": \"server-$1\"/" package.json

# Install dependencies
npm i -E express dotenv cors helmet jsonwebtoken bcryptjs cookie-parser body-parser
npm i -DE nodemon morgan standard

# Prompt for installing eslint
read -r -p "Do you want to install eslint? (y/n): " install_eslint
if [[ $install_eslint =~ ^[Yy]$ ]]; then
  npm install -DE eslint@8.57.0 eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise@6.6.0 eslint-plugin-unused-imports eslint-plugin-jsdoc

  # Check and copy .eslintrc.json template
  if [ -f "$script_dir/template_eslintrc.json" ]; then
    cp "$script_dir/template_eslintrc.json" ./.eslintrc.json
  else
    echo "Error: template_eslintrc.json file not found."
  fi
fi

# Prompt for installing swagger
read -r -p "Do you want to install swagger? (y/n): " install_swagger
if [[ $install_swagger =~ ^[Yy]$ ]]; then
  npm i -E swagger-jsdoc swagger-ui-express
  touch src/config/swagger.js
fi

# Prompt for installing mongoose
read -r -p "Do you want to install mongoose? (y/n): " install_mongoose
if [[ $install_mongoose =~ ^[Yy]$ ]]; then
  npm i -E mongoose
else
  # Prompt for installing prisma if mongoose is not installed
  read -r -p "Do you want to install prisma? (y/n): " install_prisma
  if [[ $install_prisma =~ ^[Yy]$ ]]; then
    npm i -E prisma
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
echo "# $1" > README.md
echo "type *npm run dev* for starting the developing mode" >> README.md

# Display success message
echo "Setup completed successfully!"

# Prompt for starting coding
read -r -p "Do you want to start coding now? (y/n): " start_coding
if [[ $start_coding =~ ^[Yy]$ ]]; then
  code .
fi
