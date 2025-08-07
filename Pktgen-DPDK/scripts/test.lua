-- Latency + Throughput Demo Script

package.path = package.path ..";?.lua;test/?.lua;app/?.lua;../?.lua"
require "Pktgen"
local constants = require("./scripts/constants")

local port = 0
local sleeptime = 10


pktgen.stop(port)
pktgen.clear(port)
pktgen.clr()
pktgen.delay(100)

-- Configuration
pktgen.set(port, "size", 64)
pktgen.set(port, "rate", 100)
pktgen.set(port, "count", 0)

pktgen.set_mac(port, "dst", "08:c0:eb:b6:e8:05")
pktgen.set_mac(port, "src", "08:c0:eb:b6:cd:5d")
pktgen.set_ipaddr(port, "dst", "10.0.1.8")
pktgen.set_ipaddr(port, "src", "10.0.1.7/24")


-- Set up Range configuration
pktgen.range.ip_proto("all", "tcp");

pktgen.range.dst_mac(port, "start", "08:c0:eb:b6:e8:05");
pktgen.range.src_mac(port, "start", "08:c0:eb:b6:cd:5d");


pktgen.range.dst_ip(port, "start", "10.0.1.8");
pktgen.range.dst_ip(port, "inc", "0.0.0.0");
pktgen.range.dst_ip(port, "min", "10.0.1.8");
pktgen.range.dst_ip(port, "max", "10.0.1.8");

pktgen.range.src_ip(port, "start", "10.0.1.7");
pktgen.range.src_ip(port, "inc", "0.0.0.0");
pktgen.range.src_ip(port, "min", "10.0.1.7");
pktgen.range.src_ip(port, "max", "10.0.1.7");

pktgen.range.src_port(port, "start", 20000);
pktgen.range.src_port(port, "inc", 1);
pktgen.range.src_port(port, "min", 20000);
pktgen.range.src_port(port, "max", 20255);

pktgen.range.dst_port(port, "start", 20000);
pktgen.range.dst_port(port, "inc", 1);
pktgen.range.dst_port(port, "min", 20000);
pktgen.range.dst_port(port, "max", 20255);

pktgen.range.ttl(port, "start", 64);
pktgen.range.ttl(port, "inc", 0);
pktgen.range.ttl(port, "min", 64);
pktgen.range.ttl(port, "max", 64);

pktgen.set_range(port, "on");

pktgen.delay(100)



-- pktgen.latency(port, "rate", 1000)
-- pktgen.latency(port, "entropy", 16)
-- pktgen.latency(port, "enable")

printf("Start sending traffic on port %d\n", port)
pktgen.start(port)

printf("Sleeping for %d seconds...\n", sleeptime)
pktgen.sleep(sleeptime)
printf("Sleep done\n")

pktgen.stop(port)
-- pktgen.latency(port, "disable")

local stats = pktgen.pktStats(port)

local outfile = io.open("./logs/pktgen_stats.txt", "w")

for k, v in pairs(stats[port]) do
    if k == "latency" and type(v) == "table" then
        outfile:write(string.format("%s = %s\n", k, tostring(v)))
        for subk, subv in pairs(v) do
            outfile:write(string.format("\t%s = %s\n", subk, tostring(subv)))
        end
    else
        outfile:write(string.format("%s = %s\n", k, tostring(v)))
    end
end

outfile:close()


local ip_pkts_perQ = stats[port].ip_pkts / constants.NUM_Q or 0

local duration_sec = sleeptime

local tx_mpps = (ip_pkts_perQ / duration_sec) / 1e6
printf("TX Rate on port %d: %.2f Mpps\n", port, tx_mpps)