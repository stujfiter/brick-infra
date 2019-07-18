jq '.Reservations[] | .Instances[]| .PublicIpAddress' instances.json

