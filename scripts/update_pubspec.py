import requests
import yaml
import json


def fetch_latest_version(package_name):
    url = f"https://pub.dev/api/packages/{package_name}"
    response = requests.get(url)
    response.raise_for_status()
    package_data = response.json()
    latest_version = package_data['latest']['version']
    return latest_version


def update_dependencies(pubspec_path, dependency_file):
    with open(dependency_file, 'r') as file:
        dependency_data = json.load(file)
    packages_latest = dependency_data['packages_latest']
    specified_versions = dependency_data['specified_versions']

    with open(pubspec_path, 'r') as file:
        pubspec = yaml.safe_load(file)

    # Update to latest versions
    for package in packages_latest:
        if 'dependencies' in pubspec and package in pubspec['dependencies']:
            latest_version = fetch_latest_version(package)
            pubspec['dependencies'][package] = f'^{latest_version}'

    # Update to specified versions
    for package, version in specified_versions.items():
        if 'dependencies' in pubspec and package in pubspec['dependencies']:
            pubspec['dependencies'][package] = version

    with open(pubspec_path, 'w') as file:
        yaml.dump(pubspec, file, indent=2)


# This is the path to the pubspec.yaml file
pubspec_path = './pubspec.yaml'

# Path to the JSON file with dependencies
dependency_file = './data/dependencies.json'

# Call the function to update the dependencies
update_dependencies(pubspec_path, dependency_file)
