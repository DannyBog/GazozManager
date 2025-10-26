# IAM Resources
#  * IAM Role for worker nodes
#  * IAM Role Policy Attachments for worker nodes
#  * IAM Role for the EKS cluster
#  * IAM Role Policy Attachments for the EKS cluster

# IAM role for worker nodes
resource "aws_iam_role" "worker_nodes" {
	name = "danny-portfolio-worker-nodes-role"

	assume_role_policy = jsonencode({
		Statement = [{
			Action = "sts:AssumeRole"
			Effect = "Allow"
			Principal = {
				Service = "ec2.amazonaws.com"
			}
		}]
		Version = "2012-10-17"
	})

	tags = merge(var.tags, {
		expiration_date = var.expiration_date
	})
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
	role       = aws_iam_role.worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "worker_cni_policy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
	role       = aws_iam_role.worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "worker_registry_policy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
	role       = aws_iam_role.worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
	policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
	role       = aws_iam_role.worker_nodes.name
}

# Role for the EKS cluster
resource "aws_iam_role" "eks_role" {
	name = "danny-portfolio-eks-role"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Effect = "Allow"
			Action = "sts:AssumeRole"
			Principal = {
				Service = "eks.amazonaws.com"
			}
		}]
	})

	tags = merge(var.tags, {
		expiration_date = var.expiration_date
	})
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
	role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_policy" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
	role       = aws_iam_role.eks_role.name
}
