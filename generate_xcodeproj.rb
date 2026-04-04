require 'xcodeproj'
require 'fileutils'

project_name = 'Spark'
project_path = "#{project_name}.xcodeproj"

# Clean up previous project if exists
FileUtils.rm_rf(project_path)
project = Xcodeproj::Project.new(project_path)

# Create the main target
target = project.new_target(:application, project_name, :ios, '17.0')

# Create the primary group (this corresponds to the PROJECT_NAME/ directory on disk)
main_group = project.main_group.new_group(project_name, '.')

# Improved adding logic: Directly find or create nested groups using 'find_subpath'
def add_files_recursively(main_group, base_folder, target)
  Dir.glob("#{base_folder}/**/*.swift").each do |file_path|
    file_dir = File.dirname(file_path)
    target_group = main_group.find_subpath(file_dir, true)
    
    # Check if file already exists to avoid duplicates
    existing_file = target_group.files.find { |f| f.path == file_path }
    next if existing_file
    
    file_ref = target_group.new_file(file_path)
    
    # CRITICAL: Dynamically add to the 'Sources' build phase
    target.source_build_phase.add_file_reference(file_ref)
  end
end

# Add our core folders
['App', 'Core', 'Data', 'Features'].each do |folder|
  add_files_recursively(main_group, folder, target)
end

# Add resources (Assets, Storyboards)
['Resources/**/*.xcassets', 'Resources/**/*.storyboard'].each do |pattern|
  Dir.glob(pattern).each do |asset_path|
    file_dir = File.dirname(asset_path)
    target_group = main_group.find_subpath(file_dir, true)
    asset_ref = target_group.new_file(File.expand_path(asset_path))
    target.resources_build_phase.add_file_reference(asset_ref)
  end
end

# Build Settings Tuning
target.build_configurations.each do |config|
  config.build_settings['SDKROOT'] = 'iphoneos'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['SWIFT_VERSION'] = '6.0'
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.spark.app.concept'
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  
  # MODERN PLISTS: Disable old Info.plist checking
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  
  # EXPLICITLY ENSURE INFOPLIST_FILE IS EMPTY TO PREVENT "FILE NOT FOUND" ERRORS
  config.build_settings['INFOPLIST_FILE'] = "" 
  
  config.build_settings['INFOPLIST_KEY_UILaunchStoryboardName'] = 'LaunchScreen'
  
  # Support ALL orientations (Resolves Xcode warning)
  orientations = 'UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight'
  config.build_settings['INFOPLIST_KEY_UISupportedInterfaceOrientations'] = orientations
  config.build_settings['INFOPLIST_KEY_UISupportedInterfaceOrientations_ipad'] = orientations
  
  config.build_settings['INFOPLIST_KEY_CFBundleDisplayName'] = 'Spark'
  
  # ASSETS: Set the app icon
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
  
  # SIGNING: Automate signing with user's Team ID
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  config.build_settings['DEVELOPMENT_TEAM'] = "PH7ZFXKNZC"
  config.build_settings['CODE_SIGN_IDENTITY'] = "Apple Development"
  config.build_settings['CODE_SIGNING_REQUIRED'] = "YES"
  config.build_settings['CODE_SIGNING_ALLOWED'] = "YES"
end

# Recreate schemes to ensure the new target is launchable
project.recreate_user_schemes

project.save
puts "Successfully regenerated #{project_path} with flat Absolute Paths."
