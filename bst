#include <iostream>
#include <vector>
#include <fstream>
#include <numeric>
class Node {
public:
    long long data;
    Node* left;
    Node* right;
    int height;

    Node(long long num) : data(num), left(nullptr), right(nullptr), height(1) {}

    void addNode(long long a) {
        if (a > this->data) {
            if (this->right == nullptr) {
                this->right = new Node(a);
            }
            else {
                this->right->addNode(a);
            }
        }
        else if (a < this->data) {
            if (this->left == nullptr) {
                this->left = new Node(a);
            }
            else {
                this->left->addNode(a);
            }
        }
    }
    

    Node* searchParent(long long a) {
        if (a > this->data) {
            if (this->right != nullptr) {
                if (this->right->data == a) {
                    return this;
                }
                else {
                    return this->right->searchParent(a);
                }
            }
            else {
                return nullptr;
            }
        }
        else if (a < this->data) {
            if (this->left != nullptr) {
                if (this->left->data == a) {
                    return this;
                }
                else {
                    return this->left->searchParent(a);
                }
            }
            else {
                return nullptr;
            }
        }
        return nullptr;
    }

    Node* searchNode(long long a) {
        if (this == nullptr) return nullptr;
        if (a == this->data) return this;
        if (a > this->data) {
            return (this->right != nullptr) ? this->right->searchNode(a) : nullptr;
        }
        return (this->left != nullptr) ? this->left->searchNode(a) : nullptr;
    }

    void deleteNode(long long a) {
        Node* pos = this->searchNode(a);
        if (pos == nullptr) return;

        if (pos->left == nullptr && pos->right == nullptr) {
            Node* newp = this->searchParent(a);
            if (newp != nullptr) {
                if (newp->left == pos) {
                    newp->left = nullptr;
                }
                else {
                    newp->right = nullptr;
                }
            }
            else {

                this->data = 0;
            }
        }
        // case 2
        else if (pos->right == nullptr || pos->left == nullptr) {
            Node* newp = this->searchParent(a);
            Node* child = (pos->left != nullptr) ? pos->left : pos->right;

            if (newp == nullptr) {
                this->data = child->data;
                this->left = child->left;
                this->right = child->right;
            }
            else {
                if (newp->left == pos) {
                    newp->left = child;
                }
                else {
                    newp->right = child;
                }
            }
        }
        // 3
        else {
            Node* min_node = pos->right;
            Node* min_parent = pos;

            while (min_node->left != nullptr) {
                min_parent = min_node;
                min_node = min_node->left;
            }


            pos->data = min_node->data;

            // Удаляем минимальный узел
            if (min_parent->left == min_node) {
                min_parent->left = min_node->right;
            }
            else {
                min_parent->right = min_node->right;
            }
        }
    }

    void heightLeftOrder() {
        if (this == nullptr) return;
        int leftHeight = 0;
        int rightHeight = 0;

        if (this->left != nullptr) {
            this->left->heightLeftOrder();
            leftHeight = this->left->height; // Получаем высоту левого поддерева
        }
        if (this->right != nullptr) {
            this->right->heightLeftOrder();
            rightHeight = this->right->height; // Получаем высоту правого поддерева
        }

        // Высота текущего узла
        this->height = std::max(leftHeight, rightHeight) + 1;
    }

    void leftOrder(std::vector<long long>& aa) {
        if (this->data != 0) {
            aa.push_back(this->data);
            if (this->left != nullptr) {
                this->left->leftOrder(aa);
            }
            if (this->right != nullptr) {
                this->right->leftOrder(aa);
            }
        }
    }

    int findMaxLen(int curmax) {
        int cur = 0;
        if (this->left != nullptr && this->right != nullptr) {
            cur += this->left->height + this->right->height;
            if (cur > curmax) {
                curmax = cur;
            }
            curmax = this->left->findMaxLen(curmax);
            curmax = this->right->findMaxLen(curmax);
        }

        else if (this->left != nullptr) {
            cur += this->left->height;
            if (cur > curmax) {
                curmax = cur;
            }
            curmax = this->left->findMaxLen(curmax);
        }

        else if (this->right != nullptr) {
            cur += this->right->height;
            if (cur > curmax) {
                curmax = cur;
            }
            curmax = this->right->findMaxLen(curmax);
        }

        return curmax;

    }

    long long findMaxHalfPaths(int mlen, long long cur, long long s)
    {
        long long sum = 0;

        if (this->left != nullptr && this->right != nullptr) {
            if (this->left->height + this->right->height == mlen) {
                long long toDelete = this->data;
                Node* one = this->left;
                Node* two = this->right;

                while (one->left != nullptr || one->right != nullptr) {
                    if (one->left != nullptr && (one->left->height + 1 == one->height)) {
                        one = one->left;
                    }
                    else if (one->right != nullptr && (one->right->height + 1 == one->height)) {
                        one = one->right;
                    }
                }


                sum += one->data;


                while (two->left != nullptr || two->right != nullptr) {
                    if (two->left != nullptr && (two->left->height + 1 == two->height)) {
                        two = two->left;
                    }
                    else if (two->right != nullptr && (two->right->height + 1 == two->height)) {
                        two = two->right;
                    }
                }


                sum += two->data;


                if (sum < s) {
                    s = sum;
                    cur = toDelete;
                }



            }
            if ((this->left->height - 1) * 2 >= mlen) {
                cur = this->left->findMaxHalfPaths(mlen, cur, s);
            }
            if ((this->right->height - 1) * 2 >= mlen) {
                cur = this->right->findMaxHalfPaths(mlen, cur, s);
            }

        }


        else if (this->left != nullptr) {
            if (this->height - 1 == mlen) {
                long long toDelete = this->data;
                Node* one = this->left;


                while (one->left != nullptr || one->right != nullptr) {
                    if (one->left != nullptr && (one->left->height + 1 == one->height)) {
                        one = one->left;
                    }
                    else if (one->right != nullptr && (one->right->height + 1 == one->height)) {
                        one = one->right;
                    }
                }
                sum = toDelete + one->data;
                if (sum < s) {
                    s = sum;
                    cur = toDelete;
                }
                /* return cur;*/

            }
            if ((this->left->height - 1) * 2 >= mlen) {
                cur = this->left->findMaxHalfPaths(mlen, cur, s);
            }


        }

        else if (this->right != nullptr) {
            if (this->height - 1 == mlen) {//? верно ли, что если узел справа только и (высота - 1) это длина наиб полупути то сразу возвращаем и дальше нет смысла идти
                long long toDelete = this->data;
                Node* two = this->right;
                while (two->left != nullptr || two->right != nullptr) {
                    if (two->left != nullptr && (two->left->height + 1 == two->height)) {
                        two = two->left;
                    }
                    else if (two->right != nullptr && (two->right->height + 1 == two->height)) {
                        two = two->right;
                    }
                }
                sum = toDelete + two->data;
                if (sum < s) {
                    s = sum;
                    cur = toDelete;
                }
                /*return cur;*/

            }
            if ((this->right->height - 1) * 2 >= mlen) {
                cur = this->right->findMaxHalfPaths(mlen, cur, s);
            }

        }

        return cur;

    }


};

int main() {
    // Создание корневого узла
    std::ifstream file_in("in.txt");
    std::ofstream file_out("out.txt");
    if (!file_in.is_open() || !file_out.is_open()) {
        std::cerr << "Не удалось открыть входной или выходной файл." << std::endl;
        return 1;
    }

    long long rootValue;
    file_in >> rootValue;

    Node* root = new Node(rootValue);
    while (file_in) {
        long long value;
        if (file_in >> value) {
            root->addNode(value);
        }
    }
    file_in.close();

    root->heightLeftOrder();

    int maxlen = root->findMaxLen(0);
    /*file_out << maxlen << std::endl;*/
    long long del = root->findMaxHalfPaths(maxlen, root->data, 2147483647);
    root->deleteNode(del);

    std::vector<long long> mas;
    root->leftOrder(mas);
    for (const long long& k : mas) {
        file_out << k << std::endl;
    }

    // Освобождение памяти
    delete root; // Не забудьте освободить память

    return 0;
}
