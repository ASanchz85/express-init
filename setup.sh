#!/bin/bash

# Check if a parameter is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a name for the mail folder."
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

# Create .gitignore file
echo "/node_modules" > .gitignore
echo ".env" >> .gitignore

# Create .env file
touch .env

# Copy package.json template
cp ~/scripts/template_package.json ./package.json

# Update package.json with the new name
sed -i 's/"name": "server"/"name": "'"$1"'-server"/' package.json

# Install dependencies
npm i -E express dotenv cors helmet
npm i -DE nodemon morgan standard

# Prompt for installing mongoose
read -r -p "Do you want to install mongoose? (y/n): " install_mongoose
if [[ $install_mongoose =~ ^[Yy]$ ]]; then
  npm i -E mongoose
  mkdir config models
fi

# Prompt for installing prisma if mongoose is not installed
if [ ! -z "$install_mongoose" ] && [[ ! $install_mongoose =~ ^[Yy]$ ]]; then
  read -r -p "Do you want to install prisma? (y/n): " install_prisma
  if [[ $install_prisma =~ ^[Yy]$ ]]; then
    npm i -E prisma
    mkdir config models
  fi
fi

# Display success message
echo "Setup completed successfully!"

# Prompt for starting coding
read -r -p "Do you want to start coding now? (y/n): " start_coding
if [[ $start_coding =~ ^[Yy]$ ]]; then
  code .
fi
