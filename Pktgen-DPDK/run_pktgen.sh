sudo ./build/app/pktgen -l 0-3 -n 4 --proc-type auto --log-level 0 \
  --file-prefix pktgen1 \
  --allow=0000:31:00.1 \
  -- -P -T -m "[1:2-3].0" -f ./scripts/test.lua