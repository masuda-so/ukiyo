# Third-Party Notices

This file supplements, and does not replace, the repository LICENSE. It records
Apple-distributed sample code that Ukiyo actually adapts, together with the local
scope of each adaptation. A documentation link or use of a public Apple API by
itself is not treated as copied sample code.

Apple names and links below identify sources and license terms only. Nothing in
this file states or implies that Apple sponsors, endorses, or approves Ukiyo.
Product identifiers, prompts, pricing, user-facing copy, and the 24-hour Daily
Pass policy are local work.

The shipping `ukiyo/Resources/AppIcon.icon` composition and its
`ukiyo-selected-source.png` foreground are local artwork, not Apple sample code
or an SF Symbol. Apple icon documentation informs canvas, mask, appearance, and
packaging decisions.

## Bringing Photos picker to your SwiftUI app

Source:

- https://developer.apple.com/documentation/photokit/bringing-photos-picker-to-your-swiftui-app
- Distributed sample archive: https://docs-assets.developer.apple.com/published/00f942c6d60a/BringingPhotosPickerToYourSwiftUIApp.zip

Applied scope: ukiyo/Services/Photos/ProfileModel.swift retains the distributed
photo-selection model's `ObservableObject`, `@Published` state,
`loadTransferable(from:)`, main-queue result delivery, transferable
representation, selection identity guard, and result switch. The unrelated
profile text fields are omitted; the default-equivalent injectable loader used
for deterministic tests is local. ukiyo/Components/ProfileImage.swift retains the
distributed state-rendering view. The picker in ukiyo/App/Lens/LensView.swift
retains the sample's `@StateObject` ownership and picker configuration. The
separate `LensImageTransfer`, cancellable save task, Image I/O resizing and JPEG
encoding, SwiftData persistence, captions, and product presentation are local.

The distributed LICENSE.txt states:

~~~text
Copyright © 2024 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
~~~

## Grateful Moments data-container pattern

Source:

- https://developer.apple.com/tutorials/develop-in-swift/collect-model-and-store-data
- Inspected sample archive: https://docs-assets.developer.apple.com/published/3a1c7e5364ceea203334a98884e0559e/GratefulMoments-InvestigateAndFixABug.zip

Applied scope: ukiyo/Services/Data/DataContainer.swift adapts the tutorial's
Schema, ModelConfiguration, ModelContainer, main-context, and in-memory preview
container structure. LensImage replaces the tutorial models; errors and sample
data are local.

The inspected tutorial archive LICENSE.txt states:

~~~text
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
~~~

## Adding intelligent app features with generative models

Source:

- https://developer.apple.com/documentation/foundationmodels/adding-intelligent-app-features-with-generative-models
- Distributed sample archive: https://docs-assets.developer.apple.com/published/5414fd17db13/AddingIntelligentAppFeaturesWithGenerativeModels.zip
- Apple Sample Code License: https://developer.apple.com/support/downloads/terms/apple-sample-code/Apple-Sample-Code-License.pdf

The retained kernel was compared with
FoundationModelsTripPlanner/FoundationModelsTripPlanner/Model/Itinerary/ItineraryPlanner.swift
and
FoundationModelsTripPlanner/FoundationModelsTripPlanner/Views/Itinerary/TripPlanningView.swift
in the distributed archive.

Applied scope: `ukiyo/App/Assistant/AssistantView.swift`, limited to the
body-level model-availability switch and separate unavailable presentation.
The sample's planner, stored session, instructions, tools, structured streaming,
and generation options are not retained. Ukiyo's app environment, Pro gate,
prompt field, response state, product copy, and retry behavior are local.
The executable AI adapter units are attributed separately to Coffee Game and
Origami below. This Trip Planner sample is not described as MIT licensed.

The distributed LICENSE.txt states:

~~~text
Copyright 2025 Apple Inc. All Rights Reserved.

IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
~~~

## Implementing a store in your app using the StoreKit API

Source:

- https://developer.apple.com/documentation/storekit/implementing-a-store-in-your-app-using-the-storekit-api
- Distributed sample archive: https://docs-assets.developer.apple.com/published/623bce0ddaba/ImplementingAStoreInYourAppUsingTheStoreKitAPI.zip
- Retrieved: 2026-08-04; archive verified again: 2026-08-12
- Archive SHA-256: `26c7a9ee9329ebc3e26c15300eab9d332c803edd00236b0eefdf50276eca1e5a`
- `LICENSE.txt` SHA-256: `136e1d3db1b892bc26b03969250fbf0668dafcf09ced3ec2e9fe0ac832f7e20d`
- `SKDemo/Model/SKDemoPlusStatus.swift` SHA-256:
  `43df30db78cc0fcf36cf686f07ad9ee3c414bad5e87176225855055950c7f431`
- `SKDemo/In App Purchase/CustomerEntitlements.swift` SHA-256:
  `ae3a815a82dcf0e87fbb380962cc96b782785d633f717d80ba26e181d4992ed3`

Applied scope: `ukiyo/Models/AccessLevel.swift` adapts the official access-level
enum to the app's free/Pro boundary.
`ukiyo/App/General/AppEnvironment.swift` adapts the retained transaction task,
weak capture, and isolated-deinit cancellation lifecycle to the local snapshot
boundary. Product identifiers, entitlement aggregation, and UI policy remain
local or are separately attributed.

The distributed `LICENSE.txt` states:

~~~text
Copyright 2026 Apple Inc. All Rights Reserved.

IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
~~~

## StoreKit patterns from Apple GitHub samples

Sources, pinned to the versions inspected:

- Food Truck: https://github.com/apple/sample-food-truck/tree/3954a769e99f3cc53297d94f2b960ceb2665b3d6
- Backyard Birds: https://github.com/apple/sample-backyard-birds/tree/1843d5655bf884b501e2889ad9862ec58978fdbe

The retained source kernels were compared with
FoodTruckKit/Sources/Store/StoreActor.swift in Food Truck and
Multiplatform/Shop/BirdBrain.swift in Backyard Birds.

Applied scope: `ukiyo/App/Settings/SettingsView.swift` adapts Food Truck's
subscription-management state, button, and sheet modifier;
`ukiyo/App/Settings/RestorePurchasesButton.swift` adapts Backyard Birds'
restore task, `defer`, `AppStore.sync()`, and disabled state; and
`ukiyo/Components/CardView.swift` adapts Food Truck's thin-material card kernel.
The runtime transaction loops and handler in
`ukiyo/Services/Commerce/StoreKitSubscriptionClient.swift` are not attributed
to these repositories; their primary implementation source is the fixed
StoreKit Workflows archive recorded below.

Both pinned repositories contain the same copyright and permission text:

~~~text
Copyright © 2023 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
~~~

## Additional shared interface adaptations

The following adaptations extend the scopes already described above:

- `ukiyo/App/Assistant/AssistantView.swift` adapts the body-level availability
  switch from Foundation Models Trip Planner. Its Pro gate, prompt, task, result,
  error, and product presentation remain local.
- `ukiyo/App/Settings/SettingsView.swift` adapts the subscription-management
  state, button, and sheet modifier from Food Truck's
  `App/Store/StoreSupportView.swift`.
- `ukiyo/App/Settings/RestorePurchasesButton.swift` adapts the executable view
  unit from Backyard Birds'
  `Multiplatform/Account/RestorePurchasesButton.swift`. Type and state naming,
  `defer`, `AppStore.sync()`, disabled state, and preview are retained;
  main-actor task integration, `CancellationError` handling, failure state, and
  the localized failure alert are local.
- `ukiyo/Components/CardView.swift` adapts the padding and thin-material
  continuous rounded-rectangle kernel from Food Truck's
  `App/City/CityWeatherCard.swift`.

The native `StoreView` in the paywall comes from Apple's public StoreKit API.
The `ProductID` enum and grouped arrays adapt the fixed StoreKit Workflows
source recorded below. Production product IDs, Daily Pass behavior, all copy,
catalog construction, and the surrounding composition remain local.

## Apple 2025 MIT samples for Foundation Models and StoreKit

Sources:

- Coffee Game: https://developer.apple.com/documentation/foundationmodels/generate-dynamic-game-content-with-guided-generation-and-tools
- Coffee Game archive: https://docs-assets.developer.apple.com/published/86c65aeb21cc/GenerateDynamicGameContentWithGuidedGenerationAndTools.zip
- Coffee Game archive SHA-256:
  `74296318d9d9d025c080bc19a3e266045f4eb95c59188c309d7b108fb2d3c389`
- `FoundationModelsCoffeeGame/FoundationModelsCoffeeGame/GenerateEncounters/EncounterEngine.swift:24-48`
  SHA-256:
  `f3e2cf13d7a737fcefd4a7d5226c6f57975b69fd39ab0799b101482a0e3858f2`
- `FoundationModelsCoffeeGame/FoundationModelsCoffeeGame/MainMenu/MainMenuView.swift:47-73`
  SHA-256:
  `31ec6dbebe3f7e47b9cc501cb879a2a6e84ddf3a9bdd80559d77673940851d35`
- StoreKit Workflows: https://developer.apple.com/documentation/storekit/understanding-storekit-workflows
- StoreKit Workflows archive: https://docs-assets.developer.apple.com/published/6b864cb1ff7d/UnderstandingStoreKitWorkflows.zip
- StoreKit Workflows archive SHA-256:
  `95fc0905086308fd68e0c3f5559b20b9b57d8b6663e91466fee187a170987e72`
- `StoreKitWorkflows/StoreKitWorkflows/ProductID.swift:8-32` SHA-256:
  `922eff297649cd4ea4247573f97083007599f1c2adb6235469f8804df8327b2c`
- `StoreKitWorkflows/StoreKitWorkflows/Store.swift:32-53,81-99` SHA-256:
  `9c5ef74c118b7de50ca178e8b57457f79061fa4343410bbb6318cc61fbddb6e3`

Applied scope:

- Coffee Game `MainMenuView.swift:47-73` is adapted by
  `ukiyo/Services/AI/FoundationModelAIClient.swift:14-36`
  (local file SHA-256
  `2c271680e1be35856264a354489868c82dfbe363e8bc8180c731bd8e13b05d52`)
  for the model-availability switch and named unavailable reasons.
- Coffee Game `EncounterEngine.swift:24-48` is adapted across
  `ukiyo/Services/AI/UkiyoAssistant.swift:15-35`
  (local file SHA-256
  `8bd72a8b2d60b7c69d3ac8d48c87929ceffaea28a880abaad031a46ea453b6f2`)
  and `ukiyo/Services/AI/FoundationModelAIClient.swift:38-75` for the
  separate instructions/prompt flow, session creation, `respond(to:)`, and
  `response.content`. Product text, protocol boundaries, locale and
  availability checks, cancellation conversion, and response types are local.
- StoreKit Workflows `ProductID.swift:8-32` is adapted by
  `ukiyo/Services/Commerce/UkiyoCommerceCatalog.swift:1-18`
  (local file SHA-256
  `b9243dbcd328b99e054c3cac7249e6d8c67d51f2fa742adfe22b2c7f97644fa3`).
  The enum/group structure is retained; production identifiers,
  `nonRenewables`, catalog construction, and the 24-hour policy are local
  substitutions or separate local units.
- StoreKit Workflows `Store.swift:32-48` is adapted by
  `ukiyo/Services/Commerce/StoreKitSubscriptionClient.swift:132-165`;
  `Store.swift:51-53,81-99` is adapted by the same local file at `167-179`;
  and its current-entitlements loop at `39-42` is adapted at `66-117`.
  The local file SHA-256 is
  `d7235a49655295aaf55b5c072ea5bc6a608a659b4c611a0eaa22307c32ce8348`.
  `AsyncStream`, snapshot aggregation, catalog filtering, Daily Pass
  interpretation, injected clock, cancellation, restore, and error policy are
  local.

Both distributed `LICENSE.txt` files have SHA-256
`ef80d1c2ac05c7040c0ced9d603c2c359712f90fdb3ece8da70b976981a69e89`
and contain the same notice:

~~~text
Copyright © 2025 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

~~~

## Origami Foundation Models sample

Source:

- https://developer.apple.com/documentation/foundationmodels/origami-crafting-a-dynamic-tutorial-for-apple-intelligence
- Archive: https://docs-assets.developer.apple.com/published/e843a4026a2e/OrigamiCraftingADynamicTutorialForAppleIntelligence.zip
- Archive SHA-256:
  `ce65cf2266eb8e69edf1eacdcdea82f97bda0ffed5b7accb61ab4df3c1a20c2a`
- Embedded revision: `e1705ac38f050049e8598061cda18b83a50c31b3`
- `Origami/Terms/TermModel.swift:145-163` SHA-256:
  `decd3811dd33ec96d0f787c20a8b024c4a4da78351a7e025ebec9281661a9eae`
- `Origami/Models/Error+DisplayMessage.swift:12-36` SHA-256:
  `0609f3a644c92b5f8bf64cc08a0e3390fbf4adc0e78123788e02350d5c5e4af7`

Applied scope:

- `Origami/Models/Error+DisplayMessage.swift:12-36` is adapted by
  `ukiyo/Services/AI/FoundationModelAIClient.swift:77-127`
  (local file SHA-256
  `2c271680e1be35856264a354489868c82dfbe363e8bc8180c731bd8e13b05d52`).
  The typed `SystemLanguageModel.Error` and `LanguageModelError` checks and
  fallback structure are retained. Ukiyo replaces Origami's display strings
  with stable app errors, adds supported framework cases and
  `LanguageModelSession.Error`, and guards iOS 27-only APIs.
- `Origami/Terms/TermModel.swift:145-163` is adapted by
  `ukiyo/App/General/AppEnvironment.swift:133-140`
  (local file SHA-256
  `d7ae9fd16eb6e1884c36d192181df348509deea0abc8373496d710fa7484f0c4`)
  for the await-response, cancellation-check, then publish-state order and
  cancellation-without-error behavior. Product gates, assistant abstraction,
  response state, logging, and error presentation are local.

The distributed `LICENSE.txt` has SHA-256
`d18c34e657bcc2cd125a3c9c8d731ded98e02b2abe62b885defa9991e5054649`
and states:

~~~text
Copyright © 2026 Apple Inc. All Rights Reserved.

IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
~~~

## Materials not included

LensImageTransfer.swift and ImagePreparation.swift are locally composed from
public CoreTransferable and Image I/O APIs and aren't copied from the Photos
picker sample. Public SwiftData calls used for Ukiyo's own LensImage model
likewise do not, by themselves, create another sample-code attribution.
