// Copyright Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;

public class ue6test : ModuleRules
{
	public ue6test(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PublicDependencyModuleNames.AddRange(new string[] {
			"Core",
			"CoreUObject",
			"Engine",
			"InputCore",
			"EnhancedInput",
			"AIModule",
			"StateTreeModule",
			"GameplayStateTreeModule",
			"UMG",
			"Slate"
		});

		PrivateDependencyModuleNames.AddRange(new string[] { });

		PublicIncludePaths.AddRange(new string[] {
			"ue6test",
			"ue6test/Variant_Platforming",
			"ue6test/Variant_Platforming/Animation",
			"ue6test/Variant_Combat",
			"ue6test/Variant_Combat/AI",
			"ue6test/Variant_Combat/Animation",
			"ue6test/Variant_Combat/Gameplay",
			"ue6test/Variant_Combat/Interfaces",
			"ue6test/Variant_Combat/UI",
			"ue6test/Variant_SideScrolling",
			"ue6test/Variant_SideScrolling/AI",
			"ue6test/Variant_SideScrolling/Gameplay",
			"ue6test/Variant_SideScrolling/Interfaces",
			"ue6test/Variant_SideScrolling/UI"
		});

		// Uncomment if you are using Slate UI
		// PrivateDependencyModuleNames.AddRange(new string[] { "Slate", "SlateCore" });

		// Uncomment if you are using online features
		// PrivateDependencyModuleNames.Add("OnlineSubsystem");

		// To include OnlineSubsystemSteam, add it to the plugins section in your uproject file with the Enabled attribute set to true
	}
}
