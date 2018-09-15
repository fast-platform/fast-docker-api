FROM alvrme/alpine-android:android-28

RUN apk add --update --no-cache curl nodejs nodejs-npm git wine gradle xvfb alpine-base\
  # === Install Cordova ===
  && npm install --global surge cordova \
  && cordova telemetry off \
  && npm cache clean --force \
  # === Prepare & cache Cordova Android platform & build tools
  && cordova create /tmp/dummy dummy.app DummyApp \
  && cd /tmp/dummy \
  && cordova platform add android \
  && cordova build android \
  && rm -rf /tmp/dummy

RUN npm install -g quasar-cli@0.6.5 

#RUN npm install -g cypress
RUN mkdir /tmp/app

WORKDIR /tmp/app

VOLUME ["/tmp/app"]

CMD tail -f /dev/null

