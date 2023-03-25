'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "66135e97c9bf21cd91c13eaaa6b3f2e2",
"assets/AssetManifest.json": "3a4b7969659640d7f3f46301b32f0b03",
"assets/assets/images/ara-1.jpg": "555a2776caa10768f87d7b2fe841d0ba",
"assets/assets/images/ara-10.jpg": "c1f3484abb0354650810cfdced06fbbd",
"assets/assets/images/ara-2.jpg": "1144227414a0bbf187864e1957bf9271",
"assets/assets/images/ara-3.jpg": "12aa0c4eeefe5248f93deaff9bc3e42b",
"assets/assets/images/ara-4.jpg": "70e2e8c843ab86d8465b4823fe2762eb",
"assets/assets/images/ara-5.jpg": "7a838135216db19946f07531601628df",
"assets/assets/images/ara-6.jpg": "b0b954e4f5a5d8e5064af01b753ceb9a",
"assets/assets/images/ara-7.jpg": "a2bf9c4858b625bc0c07930405e91699",
"assets/assets/images/ara-8.jpg": "8fc9e0dab1357a9bd0923610b4c60d51",
"assets/assets/images/ara-9.jpg": "41db1492f1d4346b756575af11d3bb27",
"assets/assets/images/ex1.png": "7d82fc0d7db08f7d72b53f40c664f8c2",
"assets/assets/images/level-0.jpg": "9aedd78cb46eb1f065747b0ccaea687e",
"assets/assets/images/level-1.jpg": "fcba71e13df683add34aae609b9ca646",
"assets/assets/images/level-2.jpg": "aa448fbfb6c52cd4a874b41a9011e754",
"assets/assets/images/level-3.jpg": "5abcd26f800f1d3bac78728fe1fbe2dc",
"assets/assets/images/level-4.jpg": "07374666f2c617d3886580866368eb0f",
"assets/assets/images/level-5.jpg": "d64488de87fd37c17b0964222b005d0a",
"assets/assets/images/ora-1.jpg": "a649cb07fa0b6b92d352ac5a5f5e9d8e",
"assets/assets/images/ora-10.jpg": "4634b5363a9192288ea2cd193f307c4d",
"assets/assets/images/ora-2.jpg": "72d63975867172ac903fc7b4ba9e23be",
"assets/assets/images/ora-3.jpg": "65779d2a47311d64dd5b9b773912d815",
"assets/assets/images/ora-4.jpg": "c6ea7d54e163108874820df2b431961b",
"assets/assets/images/ora-5.jpg": "f59ae9cfc67dbece9d884ae9c48b7cbe",
"assets/assets/images/ora-6.jpg": "87fde0a0aa39ccdb82c084efad1ced20",
"assets/assets/images/ora-7.jpg": "379fb3a4647cf9410c2e957ac325630b",
"assets/assets/images/ora-8.jpg": "96d518b224e82582d386919e60878dcb",
"assets/assets/images/ora-9.jpg": "29a57ec3d7b63a59ede4b07160d86dce",
"assets/assets/images/user.png": "1300018473cc0038187aaa0e2604fa27",
"assets/assets/svg/bell.svg": "4a86ba9c8da0ed9146d7ba88e89d7780",
"assets/assets/svg/chat_off.svg": "a509a570599f2a832ff56b5a07a72c45",
"assets/assets/svg/chat_on.svg": "b38bd3269638336d595b4edda2079f83",
"assets/assets/svg/heart_off.svg": "7746f5e4d82a2cf71a3d1f30fdef6ace",
"assets/assets/svg/heart_on.svg": "0f0a056e8d5201f34189fc50f0566f97",
"assets/assets/svg/home_off.svg": "6f087f95ffc4946f72d8d4e7513ca13e",
"assets/assets/svg/home_on.svg": "8b41ca2e4953bb7e8cc248acee31994a",
"assets/assets/svg/location_off.svg": "5e0e38c20f2cde867f98302dfafa784c",
"assets/assets/svg/location_on.svg": "bb11aea1ef27667cd60630eedcf17c79",
"assets/assets/svg/notes_off.svg": "7db858ae65179a91e873cc755e906572",
"assets/assets/svg/notes_on.svg": "cbe4df50863e83bdbc77300af09479cc",
"assets/assets/svg/user_off.svg": "7de5e5f7d3fbd734c8d9328cc6806365",
"assets/assets/svg/user_on.svg": "47be60baa8a7281a95b735338d2d4b18",
"assets/FontManifest.json": "71a4a82de411f155107da3f8dac64ebd",
"assets/fonts/MaterialIcons-Regular.otf": "ac7f673475ab634fe82273cfbdf014e6",
"assets/NOTICES": "c1dfab8ee1d4dc5a07c13337e171cdb7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "57f2f020e63be0dd85efafc7b7b25d80",
"canvaskit/canvaskit.js": "3e7c7e90ff8e206f4023c12e31b0d058",
"canvaskit/canvaskit.wasm": "35222aaf0d06f6dfba5b13782f7ff32e",
"canvaskit/chromium/canvaskit.js": "c5ff0f8767a7ea0962b15d1f1832002d",
"canvaskit/chromium/canvaskit.wasm": "7e8555fa0fbf19a88ba6ea83d02eda6d",
"canvaskit/skwasm.js": "3dbd05be6db4a4154ce733ff194dcae7",
"canvaskit/skwasm.wasm": "c0e1e265faeb6428fdeb9bc37be480f9",
"canvaskit/skwasm.worker.js": "23be0fdafa5ddef67734292a576f8fe3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "65d8f5d900038cad3362b33c5a64e76e",
"/": "65d8f5d900038cad3362b33c5a64e76e",
"main.dart.js": "ad9c9bcc545630b0c8de9e8d9761c910",
"manifest.json": "fd091ea5bc8f3ccc10f74bd67179fb6a",
"version.json": "f0aa2613ca08d4fad50e06af77b940f7"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
