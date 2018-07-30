
echo "Adding Formio Service"
docker exec compose_kong_1 /bin/sh -c "
  curl -i -X POST \
  --url http://kong:8001/services/ \
  --data 'host=formio' \
  --data 'protocol=http' \
  --data 'name=Formio' \
  --data 'port=3001' \
  --data 'path=/'
"

echo "Adding Formio Route"
docker exec compose_kong_1 /bin/sh -c "
  curl -i  \
  -X POST \
  --url http://kong:8001/services/Formio/routes \
  --data 'strip_path=true' \
  --data 'preserve_host=false' \
  --data 'paths[]=/formio' \
  --data 'methods[]=DELETE' \
  --data 'methods[]=POST' \
  --data 'methods[]=PUT' \
  --data 'methods[]=GET' \
  --data 'protocols[]=https' \
  --data 'protocols[]=http' \
"

echo "Adding OpenCpu Service"
docker exec compose_kong_1 /bin/sh -c "
  curl -i -X POST \
  --url http://kong:8001/services/ \
  --data 'host=opencpu' \
  --data 'protocol=http' \
  --data 'name=OpenCpu' \
  --data 'port=80' \
  --data 'path=/ocpu'
"

echo "Adding OpenCpu Route"
docker exec compose_kong_1 /bin/sh -c "
  curl -i  \
  -X POST \
  --url http://kong:8001/services/OpenCpu/routes \
  --data 'strip_path=true' \
  --data 'preserve_host=false' \
  --data 'paths[]=/opencpu' \
  --data 'methods[]=POST' \
  --data 'methods[]=GET' \
  --data 'protocols[]=https' \
  --data 'protocols[]=http' \
"

echo "Adding IronFunctions Service"
docker exec compose_kong_1 /bin/sh -c "
  curl -i -X POST \
  --url http://kong:8001/services/ \
  --data 'host=ironfunctions' \
  --data 'protocol=http' \
  --data 'name=IronFunctions' \
  --data 'port=8080' \
  --data 'path=/r'
"

echo "Adding IronFunctions Route"
docker exec compose_kong_1 /bin/sh -c "
  curl -i  \
  -X POST \
  --url http://kong:8001/services/IronFunctions/routes \
  --data 'strip_path=true' \
  --data 'preserve_host=false' \
  --data 'paths[]=/function' \
  --data 'methods[]=DELETE' \
  --data 'methods[]=POST' \
  --data 'methods[]=PUT' \
  --data 'methods[]=GET' \
  --data 'protocols[]=https' \
  --data 'protocols[]=http' \
"