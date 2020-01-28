#!/usr/bin/gawk -f

/Running test case/ {
    test_case = substr($4,2,1);
}

/Running trial number/ {
    trial = substr($4,2,1);

    pods["Running"] = 0;
    pods["ContainerCreating"] = 0;
}

/^nginx-deployment/ {
    status = $3;
    pods[status] += 1;
}

/summary =/ {
    rate = $16;
}

/Meets SLA/ {
    res = $4;
    total = pods["Running"] + pods["ContainerCreating"];
    print test_case, trial, pods["Running"], pods["ContainerCreating"], total, res, rate;
    #for (status in pods) {
        #print status, pods[status];
    #}
}

