function ekc {
    $env:kubeconfig = $args
}

function k {
    kubectl $args
}

function kg {
    k get $args
}

function kd {
    k describe $args
}

function kgp {
    k get pod
}

function kdp {
    k describe pod $args
}
