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

function kc {
    if ($args.Length -eq 0) {
        k config get-contexts
    }
    elseif ($args[0].StartsWith("~")) {
        $contexts = k config get-contexts --output name
        k config use-context $contexts[$args[0].Substring(1)]
    }
    else {
        k config use-context $args[0]
    }
}