(()=>{var e,t,a,r,i,n;r=console,n=e=>new Promise((t=>setTimeout(t,e))),a=location.host,i=async e=>{var t,r,i;if(new URL(e.url).host!==a){t={credentials:"omit",mode:"cors"};try{i=await fetch(e,t)}catch(a){a,delete t.mode,i=await fetch(e,t)}}else i=await fetch(e);return i&&(i.ok=[200,304].indexOf(i.status)>=0,i.ok&&(r=new Response(i.clone().body,i),caches.open(1).then((t=>t.put(e,r))))),i},e=0,t={install:e=>e.waitUntil(skipWaiting()),activate:e=>e.waitUntil(clients.claim()),fetch:t=>{var o,s,c,l,h;if(({method:s}=l=t.request),!(["GET","OPTIONS"].indexOf(s)<0)&&(({host:o}=h=new URL(l.url)),o===a))return({pathname:c}=h),c.indexOf(".")<0?l=new Request("/",{method:s}):"/.v"===c&&i(l).catch((e=>r.error(l,e))),t.respondWith(caches.match(l).then((async a=>{var o,s,c,h,d,u;if(a)return a;for(h=void 0;;){for(;(c=(d=new Date)-e)<1e3;)await n(c);try{if(!(null!=(u=await i(l))?u.ok:void 0))throw Error(await u.text());return h&&o&&o.postMessage(["O",l.url]),u}catch(a){h=a,e=d,({clientId:s}=t),r.error(h,l,u),s&&null!=(o=await clients.get(s))&&o.postMessage(["X",l.url])}}})))}},(()=>{var e,a,r;for(e in a=[],t)r=t[e],a.push(addEventListener(e,r))})()})();