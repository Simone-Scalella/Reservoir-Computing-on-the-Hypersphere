# Reservoir computing on the hypersphere
import numpy as np


def init(M, N):
    u, v = np.random.rand(N, M), np.identity(M)
    for m in range(M):
        u[:, m] = u[:, m] - u[:, m].mean()
        u[:, m] = u[:, m] / np.linalg.norm(u[:, m])
    return u, v


def recall(T, N, w, u, c, a, ss):
    x, i = np.zeros(N), ci[ss]

    # print("il ui:   " + str(u[i]))
    for t in range(T - 1):
        x = (1.0 - a) * x + a * (u[:, i] + np.roll(x, 1))
        # print("il x:   " + str(x))
        x = x / np.linalg.norm(x)
        y = np.exp(np.dot(w, x))
        # print("y value: " + str(y))   # DGN
        i = np.argmax(y / np.sum(y))
        print("i value: " + str(i))  # DGN
        # print("il i:   " + str(i))
        ss = ss + str(c[i])
    return ss


def error(s, ss):
    err = 0.
    for t in range(len(s)):
        err = err + (s[t] != ss[t])
    return np.round(err * 100.0 / len(s), 2)


def offline_learning(u, v, c, a, s):
    T, (N, M), eta = len(s), u.shape, 1e-7
    X, S, x = np.zeros((N, T - 1)), np.zeros((M, T - 1)), np.zeros(N)
    for t in range(T - 1):
        x = (1.0 - a) * x + a * (u[:, ci[s[t]]] + np.roll(x, 1))
        x = x / np.linalg.norm(x)
        X[:, t], S[:, t] = x, v[:, ci[s[t + 1]]]
    XX = np.dot(X, X.T)
    for n in range(N):
        XX[n, n] = XX[n, n] + eta
    w = np.dot(np.dot(S, X.T), np.linalg.inv(XX))
    # print("il w e': " + str(w) + "size: " + str(len(w)) + str(len(w[1])))
    ss = recall(T, N, w, u, c, alpha, s[0])
    print("err= ", error(s, ss), "%\n", ss, "\n")
    return ss, w


def online_learning(u, v, c, a, s):
    T, (N, M) = len(s), u.shape
    w, err, tt = np.zeros((M, N)), 100., 0
    while err > 0 and tt < T:
        x = np.zeros(N)
        for t in range(T - 1):
            x = (1.0 - a) * x + a * (u[:, ci[s[t]]] + np.roll(x, 1))
            x = x / np.linalg.norm(x)
            p = np.exp(np.dot(w, x))
            # print("il w e': " + str(w)) # DGN
            # print("il p e': " + str(p)) # DGN
            p = p / np.sum(p)
            w = w + np.outer(v[:, ci[s[t + 1]]] - p, x)
        ss = recall(T, N, w, u, c, a, s[0])
        err, tt = error(s, ss), tt + 1
        print(tt, "err=", err, "%\n", ss, "\n")
    return ss, w


s = "ciao,1234567890"
np.random.seed(12345)
c = list(set(s))
# print(c)
ci = {ch: m for m, ch in enumerate(c)}
T, M = len(s), len(c)
N, alpha = int(0.5 * T), 0.5

u, v = init(M, N)
print(u, v)
# ss, w = offline_learning(u, v, c, alpha, s)
ss, w = online_learning(u, v, c, alpha, s)

print(T, N, M, alpha)
print(ci)
print(ci[s[T - 1]])
print(T)
print(range(T - 1))
