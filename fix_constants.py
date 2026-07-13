import os

onboard = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/onboarding/onboarding_slides_screen.dart'
with open(onboard, 'r') as f:
    content = f.read()

content = content.replace("static const List<_OnboardingSlide> _slides = [", "List<_OnboardingSlide> get _slides => [")
with open(onboard, 'w') as f:
    f.write(content)

profile = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/profile_screen.dart'
with open(profile, 'r') as f:
    content = f.read()

content = content.replace("              const Card(\n                child: Padding(\n                  padding: EdgeInsets.symmetric(vertical: 8),\n                  child: LanguageSelector(),\n                ),\n              ),", "              const Card(\n                child: Padding(\n                  padding: EdgeInsets.symmetric(vertical: 8),\n                  child: LanguageSelector(),\n                ),\n              ),".replace('const Card', 'Card'))

with open(profile, 'w') as f:
    f.write(content)

print("Fixed constants")
